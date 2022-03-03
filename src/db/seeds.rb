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
users = User.all

# 管理者がフォローする
following = users[1..17] # user(2~18) 17人
following.each { |followed| user1.follow(followed) }
# 管理者がフォローされる
followers = users[3..26] # user(4~27) 24人
followers.each { |follower| follower.follow(user1) }
# 管理者へフォロー通知
followers.each do |follower|
  Notification.create!({
    visitor_id: follower.id,
    visited_id: 1,
    post_id: nil,
    comment_id: nil,
    action: "follow",
    checked: false
  })
end

# ゲストがフォローする
following = users[3..10] # user(4~11) 8人
following.each { |followed| user2.follow(followed) }
# ゲストがフォローされる
followers = users[4..11] # user(5~12) 8人
followers.each { |follower| follower.follow(user2) }
# ゲストへフォロー通知
followers.each do |follower|
  Notification.create!({
    visitor_id: follower.id,
    visited_id: 2,
    post_id: nil,
    comment_id: nil,
    action: "follow",
    checked: false
  })
end

# _______________________________________________________
# いいね
posts = Post.all
user1 = User.first
user2 = User.second
user3 = User.third
user4 = User.fourth

# 管理人がいいねする投稿 (post_id)
likes_posts = posts[1..10] # 計10投稿
likes_posts.each { |post| user1.like(post) }
# ゲストがいいねする投稿
likes_posts = posts[4..8] # 5投稿
likes_posts.each { |post| user2.like(post) }
# user3がいいねする投稿
likes_posts = posts[0..3] # 3投稿
likes_posts.each { |post| user3.like(post) }
# user4がいいねする投稿
likes_posts = posts[3..5] # 3投稿
likes_posts.each { |post| user4.like(post) }

# ゲストにいいね通知
# ゲストの投稿集
guest_posts = Post.where("user_id=?", 2).take(9)
guest_posts.each do |guest_post|
  # ゲストのある投稿にいいねしたユーザー達
  iine_users = guest_post.like_users
  iine_users.each do |iine_user|
    Notification.create!({
      visitor_id: iine_user.id, # いいねした人
      visited_id: 2,
      post_id: guest_post.id, # ゲストの投稿id
      comment_id: nil,
      action: "like",
      checked: false
    })
  end
end
