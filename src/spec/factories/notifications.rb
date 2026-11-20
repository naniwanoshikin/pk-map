# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    visitor_id { 1 }
    visited_id { 1 }
    post_id { 1 }
    action { 'MyString' }
    checked { false }
  end
end
