# PKmap
```
息抜きに地元で運動できる場所を探しませんか。
全国の公園や人気のスポットを紹介するサービスです。
```
<!--
目的: googlemapのような情報の蓄積 Twitterのような呟きではない

苦労したこと

導入、環境構築: 正直これが一番しんどかった
- docker 理解不十分
- cicd: プルリクエスト, build, test
- devise 理解イマイチ
- rspec まだ全然手をつけてない
- webpack_JS 理解不十分
- bootstrap 3.4.1 → 4.5.0 結局CDNで読み込んだ

方針
- わからないことをメモして1つ1つ潰していった
感想
- フロントとバックエンドの両立の難しさ 手が回らない
- JSの読み込み時間がかかる...
- 課題を1つ潰しても他の課題が相乗的に増えていく期待と不安

フロントエンド
- レスポンシブ スマホでは下端にfooterを固定
- 通知マーク➓の(header/footer)別で大きさ調整 position: relative
- 一覧のグリッドレイアウト Bootstrapのrow col (home, users/show)
- <div>構成の知識や方法が知らない 人のgithubを見た
- slimによるコード量削減がすごい

バックエンド
- 地図の表示 gon: JSにインスタンス変数を入れる
  - Homeページ  ピンは複数 + 吹き出し
  - 詳細ページ  ピンは1つ
- 基本ロジック MVC
  - seed: (フォロー、いいね、コメント) * 通知
  - フォーム送信のpath 作成・削除 (routes, posts/show, comments/comment)

インフラ
- Docker
  - 3つの環境
  - 何10分も時間がかかる

参考
- メルカリ, インスタ, googlemap, amazon
- その他


-->

## 公開ページ
[こちら](https://rails-pk.herokuapp.com/)の画面からゲストログインできます。

|ログイン後|コメント画面|
|---|---|
|![map1](https://user-images.githubusercontent.com/67915047/157975655-bfceb0a0-667a-4e14-b5e0-993cf8482ed0.jpg)|![map3](https://user-images.githubusercontent.com/67915047/158097271-b1fca94e-6d1a-4604-98f3-7b73a28faa05.jpg)|


## 実装機能

### ユーザー関連
* ユーザー登録、編集
* ログイン (devise)
* フォロー
* コメント一覧

### スポット投稿関連
* 投稿、検索
* スポット一覧表示 GoogleMap
* コメント 星レビュー

### その他
* 通知: フォロー、いいね、コメント
* 非同期 (ajax): フォロー、いいね、ページネーション
* ページネーション (kaminari)

## 使用技術
* フロントエンド
  * HTML/CSS/Sass/JavaScript
  * Slim
  * Bootstrap 4.5.0
  * jQuery 3.4.1
* バックエンド
  * Ruby 2.6.5
  * Rails 6.1.4
  <!-- 地図を表示 -->
  * Maps JavaScript API
  <!-- 高精度で緯度経度を算出 -->
  * Geocoding API
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
  <!-- * drawio -->

## 今後の課題
* ストリートビュー表示
* チェックボックスのカラム追加
