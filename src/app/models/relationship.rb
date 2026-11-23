# frozen_string_literal: true

class Relationship < ApplicationRecord
  # 「AさんがBさんをフォローした」とする counter_cache = SQL減らす
  # フォローする側: Aさんの following_count が+1増える
  belongs_to :follower, class_name: 'User', counter_cache: :following_count
  # フォローされる側: Bさんの followers_count が+1増える
  belongs_to :followed, class_name: 'User', counter_cache: :followers_count
  # 自己フォローを禁止する (users/user)
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:follower_id, '自分自身はフォローできません') if follower_id == followed_id
  end
end
