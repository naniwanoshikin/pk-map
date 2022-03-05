# 管理ユーザー
user1 = User.create!( # 10
  name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar", # spec
  password_confirmation: "foobar",
  admin: true
)

# ゲストユーザー
user2 = User.create!(
  name:  "ゲスト田中",
  email: "guest@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
)

# 一般ユーザー 40人
40.times do |n|
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
users = User.all

# 管理者がフォローするユーザー
following = users[1..17] # user(2~18) 17人
following.each { |followed| user1.follow(followed) }
# ゲストがフォローするユーザー
following = users[3..10] # user(4~11) 8人
following.each { |followed| user2.follow(followed) }


# followers が user をフォローする
[
  [users[2..16], user1], # user(3~17) 15人 管理人
  [users[4..11], user2], # user(5~12) 8人 ゲスト
].shuffle.each { |followers, user|
  followers.shuffle.each { |follower|
    # フォロー + 通知
    follower.follow(user)
    follower.notify_to_follow!(user)
  }
}

# _______________________________________________________
# userがpostsをいいねする
posts = Post.all
user3 = User.third
user4 = User.fourth
[
  [user1, posts[1..10]], # 10投稿 管理人
  [user2, posts[4..8]], # 5投稿 ゲスト
  [user3, posts[0..3]], # 3投稿
  [user4, posts[3..5]], # 3投稿
].shuffle.each { |user, likes_posts|
  likes_posts.each { |post|
    # いいね + 通知
    user.like(post)
    user.like_and_notify!(post)
  }
}
