class Post < ApplicationRecord
  belongs_to :user

  # いいね
  has_many :likes, dependent: :destroy
  # postをいいねしたユーザー
  has_many :like_users, through: :likes, source: :user

  # 通知
  has_many :notifications, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

end
