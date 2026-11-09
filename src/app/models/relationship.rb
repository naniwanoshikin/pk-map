class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # 自己フォローを禁止する (users/user)
  validate :cannot_follow_self

  private
  def cannot_follow_self
    if follower_id == followed_id
      errors.add(:follower_id, "自分自身はフォローできません")
    end
  end
end
