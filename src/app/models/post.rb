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


  # _______________________________________________
  # 通知レコードを作成 (userがいいねする)
  def create_notification_like!(user) # Likes(C)
    # 既にいいねされているか検索 = 「ボタン連打」に備える
    temp = Notification.where([
      "visitor_id = ? and visited_id = ?
      and post_id = ? and action = ? ",
      user.id, # いいねするユーザー
      user_id, # いいねされるユーザー
      id,      # いいねした投稿
      'like'
    ])
    # いいねされていない場合
    if temp.blank?
      notification = user.active_notifications.new(
        visited_id: user_id,
        post_id: id,
        action: 'like'
      )
      # 自分の投稿にいいねした場合は、通知済み
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
