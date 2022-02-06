FactoryBot.define do
  factory :user do
    # 仮で書いてみた
    name                  { "Example User" }
    email                 { "user@example.com" }
    password              { "111111" }
    password_confirmation { "111111" }
  end
end
