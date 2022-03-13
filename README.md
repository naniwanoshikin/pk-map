# PKmap
息抜きに地元で運動できる場所を探しませんか。

全国の公園や人気のスポットを紹介するサービスです。

<!--
目的: googlemapのような情報の蓄積 Twitterのような呟きではない

苦労したこと

導入、環境構築: ぶっちゃけこれが一番しんどかった
- docker
- cicd: プルリクエスト, build, test
- devise
- rspec
- webpack_JS
- bootstrap 3 → 4

フロントエンド
- レスポンシブ スマホでは下端にfooterを固定
- 微調整 通知のベル position: relative
- <div>構成の知識や方法が知らない 人のgithubを見た

バックエンド
- 地図の表示 gon: JSにインスタンス変数を入れる
  - Homeページ  ピンは複数 + 吹き出し
  - 詳細ページ  ピンは1つ
- seed: (フォロー、いいね、コメント) * 通知
- フォーム送信のpath 作成・削除 (routes, posts/show, comments/comment)

インフラ
- Docker
  - 3つの環境
  - 何10分も時間がかかる

感想
- slimによるコード量削減がすごい
- フロントとバックエンドの両立の難しさ 手が回らない
- JSの読み込み時間がかかる...

参考
- メルカリ, インスタ, googlemap, amazon
- その他

方針
- わからないことをメモして1つ1つ潰していった

-->

## 公開ページ
[こちら](https://rails-pk.herokuapp.com/)の画面からゲストログインできます。

|ログイン前|ログイン後|
|---|---|
|![shot1](https://user-images.githubusercontent.com/67915047/156552349-62b13de9-9c28-407a-ab60-dec68d50429f.png)|![map1](https://user-images.githubusercontent.com/67915047/157975655-bfceb0a0-667a-4e14-b5e0-993cf8482ed0.jpg)|


## 実装機能

### ユーザー関連
* ユーザー登録、プロフィール編集
* ログイン機能 (devise)
* フォロー/フォロワー機能

### 投稿関連
* スポット投稿
* スポット詳細: いいね、星レビュー機能
* 単純検索 (ransack)

### その他機能
* 通知: フォロー, いいね、コメント
* ページネーション (kaminari)
* 非同期 (ajax): フォロー, いいね, ページネーション

## 使用技術
* フロントエンド
  * HTML/CSS/Sass/Javascript
  * slim
  * Bootstrap 4.5.0
  * jQuery 3.4.1
* バックエンド
  * Ruby 2.6.5
  * Rails 6.1.4
  * Maps JavaScript API
* インフラ
  * Docker 20.10.12
  * docker-compose 2.2.3
  <!-- * Puma -->
  * MySQL 8.0
  * RSpec 3.10
    * System spec
    * Request spec
  * CircleCI
  * Heroku 7.59.2
* その他
  * Visual Studio Code
  * Git, Github
  * drawio
