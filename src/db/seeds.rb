# 管理ユーザー
user1 = User.create!( # 10
  name:  "Jason Paul",
  email: "example@railstutorial.org",
  password:              "foobar", # spec
  password_confirmation: "foobar",
  admin: true,
  address: '大阪城公園'
)

# ゲストユーザー
user2 = User.create!(
  name:  "ゲスト鈴木",
  email: "example-1@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  address: '上汐町公園'
)

# 一般ユーザー n=0
28.times do |n|
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
following = users[1..15] # user(2~16) 15人
following.each { |followed| user1.follow(followed) }
# ゲストがfollowingをフォロー
following = users[3..10] # user(4~11) 8人
following.each { |followed| user2.follow(followed) }

[
  # 管理人をフォロー
  [users[2..14].sample(10), user1], # (3~15) 10人
  # ゲストをフォロー
  [users[3..9].sample(4), user2], # (4~10)
].shuffle.each { |followers, user|
  followers.shuffle.each { |follower|
    # フォロー + 通知
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
    content: Faker::Lorem.sentence(word_count: 4),
  ) }
end

user3 = User.third
user4 = User.fourth
user5 = User.fifth
user6 = User.all[5]
user7 = User.all[6]
user8 = User.all[7]

# ヒットせず: クラフトパーク, MAXATTACK, 石が辻公園, 矢場町
[
  [user6, '住之江公園', '広いな', [
    [user3, 3, "港の方にあるよ。港町かな？"],
  ]],
  [user4, '真田山公園', 'いろんな遊具がある', [
    [user1, 4, "行きたくなる"],
  ]],
  [user4, '天王寺公園', 'アクセスがしやすい', [
    [user1, 3, "アクセスがしやすい"],
  ]],
  [user4, 'パワーアーツ', 'ピンク色の床', [
    [user3, 3, "去年ようやく2F行ったよ"],
  ]],
  [user5, '浪速公園', '壁が多くて良い', [
    [user6, 2, "そんなにだった"],
    [user7, 3, "新しいスポットになる予感"],
  ]],
  [user2, '犬山城', 'ブロックが多くて良い', [
    [user3, 3, "いいなぁ愛知行きたくてしょうがない.."],
  ]],
  [user5, '長居公園', 'かなり走れる', [
    [user1, 1, "スロープ硬いよ.."],
    [user3, 3, "まぁまぁな鉄棒"],
    [user7, 3, "ランニングしている人で行き交っている"],
  ]],
  [user6, 'MAX ATTACK', '段差が多い', [
    [user4, 4, "鉄棒ある!"],
    [user3, 4, "グライダーでキャットできたいな〜"],
  ]],
  [user5, '大阪城公園', '坂道を登った先にある', [
    [user1, 4, "歴史を感じる"],
  ]],
  [user3, '各務原市民公園', '噴水がある', [
    [user2, 5, "モンキーで段差超えられないよぉ"],
  ]],
  [user1, 'cafeくるり', 'cafeなのに施設がある!', [
    [user3, 5, "また行きたい"],
    [user2, 5, "オシャレで可愛いcafeの中にあるんだ"],
  ]],
  [user2, '鶴見緑地', '各国の土地がある', [
    [user3, 1, "歩くのがしんどすぎる.."],
    [user1, 1, "夕方になると中の門が閉まるので要注意.."],
  ]],
  [user4, '桃谷公園', '斜めのレールがある', [
    [user3, 4, "秋には紅葉で映える"],
  ]],
  [user2, '学びの森', '良い芝生だった', [
    [user4, 3, "まぁまぁな壁"],
    [user3, 4, "トリッキングバトルにうってつけ"],
    [user7, 4, "とてもやりやすい^_^"],
  ]],
  [user3, '上汐町公園', 'グライダーがきつい', [
    [user2, 3, "キャット難しいよな"],
  ]],
  [user1, '久屋大通', 'ロサンゼルス広場が消滅した', [
    [user4, 4, "ブロックが多かった"],
    [user5, 4, "枝はどうなったんだろう..."],
    [user3, 4, "スロープもうないのか..."],
    [user7, 5, "改装されて綺麗になったよね、cafeもあるし"],
  ]],
  [user5, '久宝寺緑地', '鉄棒2つもあるよ', [
    [user1, 3, "砂場もある"],
    [user3, 4, "鉄棒が1mくらいの高さでちょうどいい"],
    [user2, 3, "わいも"],
  ]],
  [user2, '矢場町駅', '大きいパイプがある', [
    [user3, 1, "歩くのしんどい..."],
    [user5, 4, "壁が噛みやすい"],
    [user4, 5, "レールしたい"],
  ]],
  [user2, '岐阜公園', '橋がある', [
    [user3, 3, "山の麓なんだよここ"],
    [user4, 4, "滝もある"],
  ]],
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
  [user1, posts.sample(4)], # 10投稿にいいね
  [user2, posts.sample(2)],
  [user3, posts.sample(2)],
  [user4, posts.sample(2)],
  [user5, posts.sample(3)],
  [user6, posts.sample(1)],
].shuffle.each { |user, likes_posts|
  likes_posts.each { |post|
    # いいねと通知
    user.like(post)
    user.notify_to_like!(post)
  }
}
