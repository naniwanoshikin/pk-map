FactoryBot.define do
  factory :user do
    # 7
    name                  { "Example User" }
    email                 { "user@example.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }
  end
end
