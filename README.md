# PKSpot
デスクワークの息抜きに地元で運動できる場所を探しませんか。

全国の人気の公園やスポットを紹介するサービスです。

![shot1](https://user-images.githubusercontent.com/67915047/156552349-62b13de9-9c28-407a-ab60-dec68d50429f.png)

<!--
スポット: 調べる
公園一覧
  鶴見緑地
鉄棒を調べる
  高さ情報
壁
スロープ
登録
  トレーサー情報
  名前(匿名)
  年齢
  出身
口コミ
鉄棒よかった〜
段差がちょうどいい

苦労したところ

フロントエンド
- レスポンシブ footer はスマホ画面では下端にする
- 通知のベルマークの微調整 position: relative
- slimによるコード量削減
バックエンド
- いいね通知 seed の書き方

-->

## 公開ページ
[こちら](https://rails-pk.herokuapp.com/)です。ホーム画面からゲストユーザーでログインできます。

## 実装機能

### ユーザー関連
* ユーザー登録、プロフィール編集
* ログイン機能 (devise)
* フォロー/フォロワー機能

### 投稿関連
* 投稿詳細画面

### その他機能
* 通知 (フォロー, いいね)
* ページネーション (kaminari)
* 非同期通信 (ajax) (フォロー, いいね, ページネーション)

## 使用技術
* フロントエンド
  * HTML/CSS/Sass/slim
  * Bootstrap 3.4.1
  * jQuery 3.4.1
* バックエンド
  * Ruby 2.6.5
  * Rails 6.1.4
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
