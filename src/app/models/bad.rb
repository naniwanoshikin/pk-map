class Bad < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, presence: true
  validates :review_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
