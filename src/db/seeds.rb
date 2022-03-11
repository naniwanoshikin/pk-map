# 管理ユーザー
user1 = User.create!( # 10
  name:  "Jason Paul",
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
  address: '上本町'
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
    password_confirmation: password,
    address: Faker::Address.city
    # https://github.com/faker-ruby/faker
  )
end

# _______________________________________________________
# 投稿ユーザー数
users = User.order(:created_at).take(15)
# 一人当たりの投稿数
6.times do
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
  [users[2..14], user1], # user(3~5) 13人 管理人
  [users[4..11], user2], # user(5~12) 8人 ゲスト
].shuffle.each { |followers, user|
  followers.shuffle.each { |follower|
    # フォローと通知
    follower.follow(user)
    follower.notify_to_follow!(user)
  }
}

# _______________________________________________________
# userがpostsをいいね
posts = Post.all
user3 = User.third
user4 = User.fourth
user5 = User.fifth
user6 = User.all[5]
[
  [user1, posts[1..10]], # 10投稿 管理人
  [user2, posts[4..8]], # 5投稿 ゲスト
  [user3, posts[0..3]], # 3投稿
  [user4, posts[3..5]], # 3投稿
  [user5, posts[2..5]], # 4投稿
].shuffle.each { |user, likes_posts|
  likes_posts.each { |post|
    # いいねと通知
    user.like(post)
    user.notify_to_like!(post)
  }
}

# _______________________________________________________
# userがそのpostに対してコメント
[
  [user1, posts[1], 5, "かなりいい鉄棒"],
  [user1, posts[3], 4, "壁が噛みやすい"],
  [user1, posts[4], 1, "滑ってしまう"],
  [user1, posts[8], 3, "程よい鉄棒"],
  [user2, posts[0], 3, "まぁまぁな壁"],
  [user2, posts[5], 4, "レールがちょうどいい"],
  [user2, posts[8], 4, "良質な芝生だった"],
  [user3, posts[3], 4, "鉄棒が1mくらいの高さでちょうどいい"],
  [user3, posts[1], 5, "とてもやりやすい^_^"],
  [user4, posts[2], 4, "アクセスがしやすい"],
  [user4, posts[2], 4, "ブロックが多くて良い"],
  [user5, posts[3], 4, "鉄棒よかった〜"],
  [user5, posts[5], 1, "最悪"],
  [user6, posts[10], 2, "そんなにだった"],
].shuffle.each do |user, post, score, content|
  # userがコメント
  comment = user.comments.create!(
    post_id: post.id, # コメント先の投稿
    score: score,     # 投稿の点数
    content: content, # コメント内容
  )
  # 通知
  user.notify_to_comment!(post, comment.id)
end
