FactoryBot.define do
  factory :user do
    # 7
    name                  { "Example User" }
    # 一意の値を生成
    sequence(:email) { |n| "user#{n}@example.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }

    # FactoryBot.create(:user, :admin)の形で呼び出し
    trait :admin do
      admin { true }
    end
  end

end
