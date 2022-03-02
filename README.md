# PKSpot
デスクワークの息抜きに地元で運動できる場所を探しませんか。

全国の人気の公園やスポットを紹介するサービスです。

<!--
example@railstutorial.org
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
段差がちょうどいい -->

## 公開URL
Webページは[こちら](https://rails-pk.herokuapp.com/)です。

ホーム画面からゲストユーザーでログインできます。

## 実装機能

### ユーザー関連
* ユーザー登録、プロフィール編集
* ログイン機能 (devise)
* フォロー/フォロワー機能 (ajax)
* 一覧のページネーション機能 (kaminari) (ajax)

### 投稿関連

### その他機能
* 通知機能 (フォローのみ)


## 使用技術
* 開発環境
  * Ruby 2.6.5
  * Rails 6.1.4
  * Puma
  * MySQL 8.0
  * Docker 20.10.12
  * docker-compose 2.2.3
  * Git, Github
  * フロント技術
    * Sass
    * Bootstrap
    * jQuery
* テスト環境
  * RSpec 3.10
    * System spec
    * Request spec
* 本番環境
  * CircleCI
  * Heroku
