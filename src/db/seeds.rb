# 管理ユーザー
user1 = User.create!( # 10
  name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true
)

# ゲストユーザー
user2 = User.create!(
  name:  "Guest User",
  email: "guest@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
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


# _______________________________________________________
# 最初のユーザー6人
users = User.order(:created_at).take(6) # 13
# 投稿
20.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end

# _______________________________________________________
# リレーションシップ
# 一般
users = User.all
following = users[1..45] # user(2~46) 計45人
followers = users[3..40] # user(4~41) 計38人
# 管理者がフォローする
following.each { |followed| user1.follow(followed) }
# 管理者がフォローされる
followers.each { |follower| follower.follow(user1) }

following = users[3..10] # user(4~11) 計8人
followers = users[4..20] # user(5~21) + ゲスト 計17人
# ゲストがフォローする
following.each { |followed| user2.follow(followed) }
# ゲストがフォローされる
followers.each { |follower| follower.follow(user2) }

# _______________________________________________________
# 通知
[
  # user1に対して
  [4, 1, nil, nil, "follow"],
  [5, 1, nil, nil, "follow"],
  # user2に対して
  [1, 2, nil, nil, "follow"],
  [3, 2, nil, nil, "follow"],
  [5, 2, nil, nil, "follow"],
].each do |visitor, visited, post, comment, action|
  Notification.create!({
    visitor_id: visitor,
    visited_id: visited,
    post_id: post,   # 返信元id
    comment_id: comment, # 返信id
    action: action,
    checked: false
  })
end
