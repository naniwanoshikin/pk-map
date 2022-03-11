# PKSpot
息抜きに地元で運動できる場所を探しませんか。

全国の公園や人気のスポットを紹介するサービスです。

![shot1](https://user-images.githubusercontent.com/67915047/156552349-62b13de9-9c28-407a-ab60-dec68d50429f.png)

<!--

目的: googlemapのような情報の蓄積 Twitterのような呟きではない

苦労したこと

フロントエンド
- レスポンシブ スマホでは下端にfooterを固定
- 微調整 通知のベル position: relative
- JSの読み込み時間がかかる...
- 構成に関する知識も方法も知らない

バックエンド
- 地図の表示
  - homeページ JSにerbを入れる 繰り返し
  - 詳細ページ JSにインスタンス変数を入れる gon
- seed を綺麗に書く (フォロー、いいね、コメント) * 通知
- フォーム送信のpath 作成・削除 (routes, posts/show, comments/comment)

インフラ
- 環境構築
  - Docker
    - build, test
    - 3つの環境
      - RSpec
  - CircleCI
    - プルリクエストのやり方
- 何10分も時間がかかる

参考
- メルカリ, インスタ, googlemap, amazon
- その他

感想
- slimによるコード量削減がすごい
- フロントとバックエンドの両立の難しさ 手が回らない

-->

## 公開ページ
[こちら](https://rails-pk.herokuapp.com/)の画面からゲストログインできます。

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
  * Bootstrap 3.4.1
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
