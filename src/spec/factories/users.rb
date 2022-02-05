FactoryBot.define do
  factory :user do
    # 仮で書いてみた
    # name                  { "test" }
    sequence(:email)      { |n| "TEST#{n}@example.com" }
    password              { "test" }
    password_confirmation { "test" }
  end
end
