# frozen_string_literal: true

class Post < ApplicationRecord
  default_scope -> { order(created_at: :desc) } # 要改善
  belongs_to :user, counter_cache: true # posts_count SQL減らす

  # レビュー
  has_many :reviews, dependent: :destroy
  # 通知
  has_many :notifications, dependent: :destroy

  validates :address, presence: true
  validates :spot_quality, presence: true
  # validates :content, presence: true, length: { maximum: 140 }

  # addressが変更され、かつバリデーションエラーがない場合のみジオコーディングを実行
  geocoded_by :address
  after_validation :geocode, if: -> { address.present? && will_save_change_to_address? && errors.blank? }

  # Ransackでの検索を許可するカラムを宣言 Rails7
  def self.ransackable_attributes(_auth_object = nil)
    %w[address content created_at id latitude longitude spot_quality spot_type updated_at user_id]
  end

  # (posts/post)
  # 平均評価 3.2
  def avg_score
    # 存在チェック
    return 0.0 if reviews.empty?

    # N+1 対策 float 小数点1桁
    (reviews.sum(&:score).to_f / reviews.size).round(1)
  end

  # 平均評価 64% ⭐︎のメーター
  def review_score_percentage
    (avg_score * 100 / 5).round(1)
  end

  # (posts/show)
  # 岐阜県各務原市〜丁目（番地） までを算出
  def munic
    # DBに保存されている値が nil や 0 の場合
    return '取得エラー' if invalid_coordinates?

    # 本来はDBに保存して使い回すべき（現状維持のためのHTTP処理）
    fetch_munic_from_google_api

  # 例外処理
  rescue StandardError => e
    logger.error "Geocoding Error: #{e.message}"
    '住所取得エラー'
  end

  private

  def fetch_munic_from_google_api
    spot_name = URI.encode_www_form(
      address:,
      language: 'ja', # 住所を日本語化
      components: 'country:JP' # 検索結果を日本に限定
    )
    # APIを叩く
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?#{spot_name}&key=#{ENV.fetch('GOOGLE_GEOCODING_API')}")

    api_response = Net::HTTP.get_response(uri)
    return 'API接続エラー' unless api_response.is_a?(Net::HTTPSuccess)

    response_body = JSON.parse(api_response.body)
    results = response_body['results']

    # Google APIから結果が返ってこなかった場合
    return '住所を特定できません' if results.blank? || response_body['status'] != 'OK'

    parse_address_components(results[0]['address_components'])
  end

  def parse_address_components(components)
    # Google APIから返ってくる実際の順番: components の配列の中身は、一番細かい住所から並ぶ。
    # { 愛知県, 各務原市 岩倉市, 各務原市 岩倉市, 那加桜町 東町 / baza: 東市場屋敷, banchi: 220番地-3号
    parts = { ken: '', shi: '', tyo: '', machi: '', baza: '', banchi: '' }

    # 該当するタイプを変数に格納
    components.each do |com|
      # ken ~ machi
      extract_main_address(parts, com['types'], com['long_name'])
      # baza ~ banchi 細かい地名 (sublocality_level_3 ~ 5)
      extract_sub_address(parts, com['types'], com['long_name'])
    end
    # 取得できたものを全て結合
    "#{parts[:ken]}#{parts[:shi]}#{parts[:tyo]}#{parts[:machi]}#{parts[:baza]}#{parts[:banchi]}"
  end

  def extract_main_address(parts, types, name)
    if types.include?('administrative_area_level_1')
      parts[:ken] = name
    elsif types.include?('locality')
      parts[:shi] = name
    elsif types.include?('ward') # 政令指定都市の「区」
      parts[:shi] += name
    elsif types.include?('sublocality_level_1')
      parts[:tyo] = name
    elsif types.include?('sublocality_level_2')
      parts[:machi] = name
    end
  end

  def extract_sub_address(parts, types, name)
    if types.intersect?(%w[sublocality_level_3 sublocality_level_4])
      # 複数ヒットした場合、後ろへ結合
      parts[:baza] += name # '東市場'+'屋敷'
    elsif types.intersect?(%w[premise street_number]) # '220番地-3号'
      # 日本の正しい順番に並び替えるため
      # すでに3号が入っている場合は220番地を前に置いて-で繋ぐ 逆順で取り出す
      parts[:banchi] = if parts[:banchi].present?
                         "#{name}-#{parts[:banchi]}"
                       else
                         name
                       end
    end
  end

  def invalid_coordinates?
    latitude.blank? || longitude.blank? || (latitude.zero? && longitude.zero?)
  end
end
