# PKSpot
デスクワークの息抜きに地元の運動できる場所を探しませんか。

全国の人気の公園やスポットを紹介するサービスです。

![shot1](https://user-images.githubusercontent.com/67915047/156552349-62b13de9-9c28-407a-ab60-dec68d50429f.png)

<!--

目的: googlemapのような情報の蓄積 Twitterのような呟きではない

苦労したところ

フロントエンド
- レスポンシブ footer はスマホ画面では下端にする
- 通知のベルマークの微調整 position: relative
バックエンド
- 地図を表示すること
  JS中にerbを入れるのが難しい
  - homeページ 繰り返し
  - 詳細ページ gon
- いいね通知 seed の書き方

感想
- slimによるコード量削減がすごい
- フロントとバックエンドの両立の難しさ 手が回らない

-->

## 公開ページ
[こちら](https://rails-pk.herokuapp.com/)です。ホーム画面からゲストユーザーでログインできます。

## 実装機能

### ユーザー関連
* ユーザー登録、プロフィール編集
* ログイン機能 (devise)
* フォロー/フォロワー機能

### 投稿関連
* 情報投稿画面
* 投稿詳細画面
* いいね、コメント機能
* 単純検索 (ransack)

### その他機能
* 通知: フォロー, いいね
* ページネーション (kaminari)
* 非同期通信 (ajax): フォロー, いいね, ページネーション

## 使用技術
* フロントエンド
  * HTML/CSS/Sass/slim
  * Bootstrap 3.4.1
  * jQuery 3.4.1
* バックエンド
  * Ruby 2.6.5
  * Rails 6.1.4
  * Maps JavaScript API
* インフラ
  * Docker 20.10.12
  * docker-compose 2.2.3
  * Puma
  * MySQL 8.0
  * RSpec 3.10
    * System spec
    * Request spec
  * CircleCI
  * Heroku 7.59.2
* その他
  * Visual Studio Code
  * Git, Github
