class Post < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user

  # レビュー
  has_many :reviews, dependent: :destroy
  # 通知
  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :address, presence: true
  validates :spot_quality, presence: true
  # validates :content, presence: true, length: { maximum: 140 }

  # addressが登録されたら, 緯度経度も自動登録
  geocoded_by :address
  after_validation :geocode

  # Ransackでの検索を許可するカラムを宣言 Rails7に伴い
  def self.ransackable_attributes(auth_object = nil)
    ["address", "content", "created_at", "id", "latitude", "longitude", "spot_quality", "spot_type", "updated_at", "user_id"]
  end

  # 平均評価 3.2
  def avg_score # (posts/post)
    unless self.reviews.empty?
      # 小数点1桁
      self.reviews.average(:score).round(1).to_f
    else
      0.0
    end
  end
  # 平均評価 64%
  def review_score_percentage
    unless self.reviews.empty?
      self.reviews.average(:score).round(1).to_f*100/5
    else
      0.0
    end
  end

  # 岐阜県各務原市〜丁目（番地） までを算出
  def munic # (posts/show)
    spot_name = URI.encode_www_form({
      address: self.address,
      language: 'ja', # 住所を日本語化
      components: 'country:JP' # 検索結果を日本に限定
    })
    # APIを叩く
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?#{spot_name}&key=#{ENV["GOOGLE_MAP_API"]}")

    api_response = Net::HTTP.get_response(uri)
    response_body = JSON.parse(api_response.body)

    if response_body["results"][0]
      components = response_body["results"][0]["address_components"]

      ken = "" # 愛知県 (administrative_area_level_1)
      shi = "" # 各務原市 (locality / ward)
      tyo = "" # 各務原市 (sublocality_level_1)
      machi = "" # 那加桜町 (sublocality_level_2)
      baza = "" # 東市場屋敷 細かい地名 (sublocality_level_3 / 4 / 5)
      banchi = "" # 220番地 3号 (premise / street_number)

      # 該当するタイプがあれば変数に格納
      components.each do |com|
        types = com["types"]

        if types.include?("administrative_area_level_1")
          ken = com["long_name"] # "愛知県"
        elsif types.include?("locality")
          shi = com["long_name"] # "岩倉市"
        elsif types.include?("ward") # 政令指定都市の「区」
          shi += com["long_name"]
        elsif types.include?("sublocality_level_1")
          tyo = com["long_name"] # "岩倉市"これも
        elsif types.include?("sublocality_level_2")
          machi = com["long_name"] # "東町"
        elsif types.include?("sublocality_level_3") || types.include?("sublocality_level_4")
        # 複数ヒットした場合、後ろへ結合
          baza = baza.present? ? "#{baza}#{com["long_name"]}" : com["long_name"] # "東市場屋敷"
        elsif types.include?("premise") || types.include?("street_number") # 220番地、◯号
          # すでに文字が入っている場合はハイフンで繋ぐ、無ければそのまま代入
          banchi = banchi.present? ? "#{com["long_name"]}-#{banchi}" : com["long_name"]
        end
      end
      # 取得できたものを全て結合 nilを考慮
      return "#{ken}#{shi}#{tyo}#{machi}#{baza}#{banchi}"
    end

  # 例外処理
  rescue => e
    logger.error "Geocoding Error: #{e.message}"
    return "住所取得エラー"
  end

end
