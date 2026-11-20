# frozen_string_literal: true

class Good < ApplicationRecord
  belongs_to :user
  belongs_to :review

  default_scope -> { order(created_at: :desc) }
end
