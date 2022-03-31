class Comment < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user
  belongs_to :post

  # いいね
  has_many :likes, dependent: :destroy
  # commentをいいねしたユーザー
  has_many :like_users, through: :likes, source: :user

  # 通知
  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :post_id, presence: true
  # validates :content, presence: true, length: {maximum: 100}
  validates :score, presence: true
end
