# 管理ユーザー
User.create!( # 10
  name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true
)

# 一般ユーザー
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(
  name:  name,
  email: email,
  password:              password,
  password_confirmation: password
)
end

# 最初のユーザー6人
users = User.order(:created_at).take(6) # 13
# 投稿
20.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end
