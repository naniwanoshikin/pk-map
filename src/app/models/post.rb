class Post < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user

  # コメント
  has_many :comments, dependent: :destroy
  # 通知
  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :address, presence: true
  # validates :spot_type, presence: true # seedで引っかかるため

  # addressが登録されたら, 緯度経度も自動登録
  geocoded_by :address
  after_validation :geocode

  # 平均評価 3.2
  def avg_score # (posts/post)
    unless self.comments.empty?
      # 小数点1桁
      self.comments.average(:score).round(1).to_f
    else
      0.0
    end
  end
  # 平均評価 64%
  def comment_score_percentage
    unless self.comments.empty?
      self.comments.average(:score).round(1).to_f*100/5
    else
      0.0
    end
  end

  # 岐阜県各務原市〜町 を算出
  def munic # (posts/show)
    spot_name = URI.encode_www_form({address: self.address})
    # APIを叩く
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?#{spot_name}&key=#{ENV["GOOGLE_MAP_API"]}")

    api_response = Net::HTTP.get_response(uri)
    response_body = JSON.parse(api_response.body)
    if response_body["results"][0]
      adds = response_body["results"][0]["address_components"]
      # ここの書き方が不十分 難しい...
      ken = adds[-2]["long_name"] # 県
      shi = adds[-3]["long_name"] # 市
      tyo = adds[-4]["long_name"] # 町
      return ken + shi + tyo
    end
  end

end
