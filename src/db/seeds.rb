# 管理ユーザー
user1 = User.create!( # 10
  name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar", # spec
  password_confirmation: "foobar",
  admin: true,
  address: '天王寺'
)

# ゲストユーザー
user2 = User.create!(
  name:  "ゲスト鈴木",
  email: "example-1@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  address: '新世界'
)

# 一般ユーザー 40人 n=0
40.times do |n|
name  = Faker::Name.name
email = "example-#{n+2}@railstutorial.org"
password = "password"
User.create!(
  name:  name,
  email: email,
  password:              password,
  password_confirmation: password
)
end

# _______________________________________________________
# 投稿したユーザー数
users = User.order(:created_at).take(10)
# 一人当たりの投稿数
10.times do
  # https://github.com/faker-ruby/faker
  address = Faker::Address.city
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(
    content: content,
    address: address,
  ) }
end

# _______________________________________________________
users = User.all

# 管理者がfollowingをフォロー
following = users[1..17] # user(2~18) 17人
following.each { |followed| user1.follow(followed) }
# ゲストがfollowingをフォロー
following = users[3..10] # user(4~11) 8人
following.each { |followed| user2.follow(followed) }

# followers が user をフォロー
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
    user.notify_to_like!(post)
  }
}

# _______________________________________________________
user5 = User.fifth
# userがそのpostに対してコメント
[
  [user1, posts[1], "かなりいい鉄棒"],
  [user1, posts[3], "壁が噛みやすい"],
  [user1, posts[4], "滑ってしまう"],
  [user1, posts[8], "程よい鉄棒"],
  [user2, posts[0], "まぁまぁな壁"],
  [user2, posts[5], "レールがちょうどいい"],
  [user3, posts[3], "鉄棒の高さは1mくらいでちょうどいい"],
  [user3, posts[1], "とてもやりやすい^_^"],
  [user4, posts[2], "アクセスがしやすい"],
  [user4, posts[2], "ブロックが多くて良い"],
  [user5, posts[3], "鉄棒よかった〜"],
].shuffle.each do |user, post, content|
  # userがコメント
  comment = user.comments.create!(
    post_id: post.id, # コメント先の投稿
    content: content, # コメント内容
  )
  # 通知
  user.notify_to_comment!(post, comment.id)
end