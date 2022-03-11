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
end
