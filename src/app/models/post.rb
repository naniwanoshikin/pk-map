class Post < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user

  # コメント
  has_many :comments, dependent: :destroy
  # いいね
  has_many :likes, dependent: :destroy
  # postをいいねしたユーザー
  has_many :like_users, through: :likes, source: :user
  # 通知
  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :address, presence: true
  # validates :spot_type, presence: true # seedで引っかかるため

  # addressが登録されたら, 緯度経度も自動登録
  geocoded_by :address
  after_validation :geocode

end
