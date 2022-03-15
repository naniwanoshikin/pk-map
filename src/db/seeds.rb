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

# 一般ユーザー n=0
30.times do |n|
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
users = User.all

# 管理者がfollowingをフォロー
following = users[1..17] # user(2~18) 17人
following.each { |followed| user1.follow(followed) }
# ゲストがfollowingをフォロー
following = users[3..10] # user(4~11) 8人
following.each { |followed| user2.follow(followed) }

[
  # (3~15) 10人が管理人をフォロー
  [users[2..14].sample(10), user1],
  # (5~12) 6人がゲストをフォロー
  [users[4..11].sample(6), user2],
].shuffle.each { |followers, user|
  followers.shuffle.each { |follower|
    # フォローと通知
    follower.follow(user)
    follower.notify_to_follow!(user)
  }
}

# _______________________________________________________
# 投稿
users = User.order(:created_at).take(10).sample(2)
# 一人当たりの投稿数
1.times do
  users.each { |user| user.posts.create!(
    address: Faker::Address.city,
    content: Faker::Lorem.sentence(word_count: 5),
  ) }
end

user3 = User.third
user4 = User.fourth
user5 = User.fifth
user6 = User.all[5]
user7 = User.all[6]

[
  [user6, '住之江公園', '広いな', [
    [user3, 4, "港の方にあるよ。港町かな？"],
  ]],
  [user2, '大阪城', '坂道を登った先にある', []],
  [user4, '真田山公園', 'いろんな遊具がある', [
    [user1, 4, "行きたくなる"],
  ]],
  [user4, '天王寺公園', 'アクセスがしやすい', [
    [user1, 4, "アクセスがしやすい"],
    ]],
  [user2, 'パワーアーツ', '床がピンク', [
    [user3, 3, "2F行けたらいいなぁ"],
  ]],
  [user6, 'MAX ATTACK', '段差が多い', [
    [user2, 4, "鉄棒ある!"],
    [user2, 4, "グライダーでキャットできたいな〜"],
  ]],
  [user3, '犬山城', '鉄棒が1mくらいの高さでちょうどいい', []],
  [user5, '新今宮', 'ブロックが多くて良い', [
    [user6, 2, "そんなにだった"],
    [user3, 1, "最悪"],
  ]],
  [user5, '長居公園', 'かなり走れる', [
    [user1, 1, "スロープ硬いよ.."],
    [user3, 3, "まぁまぁな鉄棒"],
    [user7, 5, "ランニングしている人で行き交っている"],
  ]],
  [user3, '各務原市民公園', '噴水がある', []],
  [user3, 'cafeくるり', '施設がある!', [
    [user3, 5, "また行きたい"],
  ]],
  [user2, '鶴見緑地', '各国の土地がある', [
    [user3, 1, "歩くのがしんどすぎる.."],
    [user1, 1, "夕方になると中の門が閉まるので要注意.."],
  ]],
  [user4, '桃谷公園', 'レールがある', [
    [user3, 4, "鉄棒が1mくらいの高さでちょうどいい"],
  ]],
  [user3, '学びの森', '良質な芝生がある', [
    [user3, 4, "良き芝生だった"],
    [user1, 5, "とてもやりやすい^_^"],
    [user3, 3, "まぁまぁな壁"],
  ]],
  [user1, '久屋大通', 'ロサンゼルス広場が消滅した', [
    [user4, 4, "ブロックが多かった"],
    [user5, 4, "枝があったなぁ..."],
    [user3, 4, "スロープもういけないのか..."],
  ]],
  [user5, '久宝寺緑地', '鉄棒よかった〜', [
    [user1, 5, "かなりいい鉄棒"],
    [user2, 4, "わいも"],
  ]],
  [user1, '矢場町', '大きいパイプがある', [
    [user3, 1, "歩くのしんどい..."],
    [user5, 4, "壁が噛みやすい"],
    [user4, 5, "レールしたい"],
    ]],
  [user1, '岐阜公園', '橋がある', [
    [user3, 4, "滝もある"],
  ]],

  # ヒットせず: クラフトパーク, MAXATTACK, 石が辻公園
].each do |user, address, content, comments|
  # userがpost
  post = user.posts.create!(
    address: address, # 住所
    content: content, # 投稿内容
  )
  # そのpostに対して複数のother_userがコメント
  comments.each do |other_user, score, his_content|
    comment = other_user.comments.create!(
      post_id: post.id, # コメント先の投稿
      score: score,     # 投稿の点数
      content: his_content, # コメント内容
    )
    # 通知
    other_user.notify_to_comment!(post, comment.id)
  end
end

# _______________________________________________________
# userがpostsをいいね
posts = Post.all[1..15]
[
  [user1, posts.sample(10)], # 10投稿にいいね
  [user2, posts.sample(2)],
  [user3, posts.sample(6)],
  [user4, posts.sample(5)],
  [user5, posts.sample(5)],
  [user6, posts.sample(2)],
].shuffle.each { |user, likes_posts|
  likes_posts.each { |post|
    # いいねと通知
    user.like(post)
    user.notify_to_like!(post)
  }
}
