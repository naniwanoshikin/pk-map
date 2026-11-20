# frozen_string_literal: true

class Bad < ApplicationRecord
  belongs_to :user
  belongs_to :review

  default_scope -> { order(created_at: :desc) }
end
