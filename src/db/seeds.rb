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
user3 = User.third
user4 = User.fourth
user5 = User.fifth
user6 = User.all[5]

users = User.order(:created_at).take(15)
# 一人当たりの投稿数
4.times do
  address = Faker::Address.city
  content = Faker::Lorem.sentence(word_count: 5)

  users.each { |user| user.posts.create!(
    address: address,
    content: content,
  ) }
end

[
  # 名古屋勢
  [user1, '久屋大通', 'ロサンゼルス広場が亡くなった'],
  [user1, '栄', 'ロサンゼルス広場が亡くなった'],
  [user1, '矢場町', '大きいパイプがある'],
  [user1, '岐阜公園', '橋がある'],
  # 大阪勢
  [user2, '大阪城', '山を登った先にある'],
  # [user2, 'パワーアーツ', 'ピンクの床'], // 詳細
  [user2, '鶴見緑地', 'レールがちょうどいい'],
  # 岐阜勢
  # [user3, '各務原市民公園', '良質な芝生だった'], // 詳細
  [user3, '犬山城', '鉄棒が1mくらいの高さでちょうどいい'],
  # 大阪勢
  [user4, '西成区', '匂いがする'],
  [user4, '天王寺', 'アクセスがしやすい'],
  # 大阪勢
  [user5, '新今宮', 'ブロックが多くて良い'],
  [user5, '長居公園', '鉄棒よかった〜'],
  # 大阪勢
  [user6, '八尾', 'めちゃくちゃいい'],
  [user6, 'クラフトパーク', '段差が多い'],
].shuffle.each do |user, address, content|
  # userが投稿
  user.posts.create!(
    address: address, # 住所
    content: content, # 投稿内容
  )
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
posts = Post.all[1..20]
[
  [user1, posts.sample(10)], # 10投稿
  [user2, posts.sample(5)], # 5投稿
  [user3, posts.sample(6)], # 6投稿
  [user4, posts.sample(3)], # 3投稿
  [user5, posts.sample(4)], # 4投稿
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
