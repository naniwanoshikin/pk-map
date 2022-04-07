# 管理ユーザー
user1 = User.create!(
  name:  "Jason Pole",
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

users = User.all
user3 = users[2]
user4 = users[3]
user5 = users[4]
user6 = users[5]
user7 = users[6]
user8 = users[7]

# _______________________________________________________
# followersがuserをフォロー
[
  [users[2..14].sample(10), user1], # (3~15) 10人
  [users[3..9].sample(5), user2],
].shuffle.each { |followers, user|
  followers.shuffle.each { |follower|
    # フォロー + 通知
    follower.follow(user)
    follower.notify_to_follow!(user)
  }
}

# userがfollowingをフォロー
[
  [user1, users[1..15]], # (2~16) 15人
  [user2, users[2..7] + [users[0]]],
].shuffle.each { |user, following|
  following.each { |followed|
    user.follow(followed)
    user.notify_to_follow!(followed)
  }
}

# _______________________________________________________
# 投稿
# ヒットせず: クラフトパーク, MAXATTACK, 石が辻公園, 矢場町
[
  [user4, '', '真田山公園', 'いろんな遊具がある。子供が多い。', [
    [user1, 4, "行きたくなる", []],
  ]],
  [user4, '普通', '天王寺公園', 'アクセスしやすい', [
    [user1, 3, "アクセスがしやすい", []],
  ]],
  [user5, '悪い', '長居公園', 'かなり走れる', [
    [user1, 1, "スロープ硬いよ..", []],
    [user8, 3, "まぁまぁな鉄棒", []],
    [user7, 3, "ランニングしている人で行き交っている", []],
  ]],
  [user4, '', 'パワーアーツ', 'ピンク色の床', [
    [user3, 3, "去年ようやく2F行ったよ", []],
  ]],
  [user5, '普通', '浪速公園', '壁が多くて良い', [
    [user6, 2, "そんなにだった", []],
    [user7, 3, "新しいスポットになる予感", []],
  ]],
  [user3, '', '上汐町公園', 'グライダーがきつい', [
    [user2, 3, "キャット難しいよな", [user5]],
  ]],
  [user2, '良い', '犬山城', '犬山といえば紅葉', [
    [user3, 3, "いいなぁ愛知行きたくてしょうがない！", [user6]],
  ]],
  [user5, '普通', '大阪城公園', '坂道を登った先にある', [
    [user1, 4, "歴史を感じる", []],
  ]],
  [user6, '良い', '明治村', '自然がいい', [
    [user3, 3, "ここまでくるのに大変だった", []],
  ]],
  [user4, '', '桃谷公園', '斜めのレールがある', [
    [user3, 4, "秋には紅葉で映える", []],
  ]],
  [user2, '普通', '鶴舞公園', 'ポール使えそう', [
    [user5, 3, "火山ラーメン行きたい", [user3]],
    [user6, 2, "無断駐輪はダメ絶対", []],
  ]],
  [user5, '普通', '久宝寺緑地', '鉄棒2つもあるよ', [
    [user1, 3, "砂場もある", []],
    [user3, 4, "鉄棒が1mくらいの高さでちょうどいい", []],
    [user2, 3, "わいも", []],
  ]],
  [user6, '', '小牧山城', '城周囲で動ける', [
    [user7, 5, "段差が多い", []],
    [user1, 4, "景色もいい", [user5]],
  ]],
  [user2, '普通', '鶴見緑地', '各国の土地がある', [
    [user3, 1, "歩くのがしんどすぎる..", []],
    [user1, 1, "夕方になると中の門が閉まるので要注意..", []],
  ]],
  [user1, '', 'cafeくるり', 'cafeなのにトランポリンがある!', [
    [user2, 5, "オシャレで可愛いcafeだよ", []],
    [user3, 5, "また行きたい", []],
  ]],
  [user3, '良い', '各務原市民公園', '噴水がある', [
    [user2, 5, "モンキーで段差超えられないよぉ", []],
  ]],
  [user2, '良い', '岐阜公園', '滝や橋がある', [
    [user4, 4, "柵ができたらしい", []],
    [user3, 3, "ここは山の麓", [user1, user2]],
  ]],
  [user2, '普通', 'エディオン久屋広場', '大きいパイプ', [
    [user7, 1, "歩くのしんどい...", [user4]],
    [user5, 4, "壁が噛みやすい", []],
    [user4, 5, "レールしたい", [user2, user3, user1]],
  ]],
  [user2, '良い', '学びの森', '良い芝生だった', [
    [user4, 3, "まぁまぁな壁", []],
    [user3, 4, "トリッキングバトルできる", [
      user3, user5, user6, user8]],
    [user7, 4, "とてもやりやすい^_^", []],
  ]],
  [user1, '普通', '久屋大通公園', '旧ロサンゼルス広場', [
    [user5, 4, "枝もないんだよね...", [user3]],
    [user3, 4, "スロープもうないんだな...", [user2, user5]],
    [user7, 5, "改装されて綺麗になったよね、cafeがある", []],
  ]],
].each do |user, quality, address, content, comments|
  # userがpostする
  post = user.posts.create!(
    content: content, # 投稿内容
    address: address, # 住所
    spot_quality: quality, # 質
  )
  comments.each do |other_user, score, his_content, good_users|
    # 複数のother_userがそのpostにコメントする
    comment = other_user.comments.create!(
      post_id: post.id, # コメント先の投稿
      score: score,     # 投稿の点数
      content: his_content, # コメント文
    )
    # 通知
    other_user.notify_to_comment!(post, comment.id)

    # good_userがそのcommentを高評価 + 通知する
    good_users.each do |good_user|
      good_user.good(comment)
      good_user.notify_to_good!(comment)
    end
  end
end
