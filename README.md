# PKmap
```
息抜きに地元で運動できる場所を探しませんか。
全国の公園や人気のスポットを紹介するサービスです。
```

## 公開ページ
[こちら](https://pk-map.herokuapp.com/)の画面からゲストログインできます。

|スポット一覧画面|スポット詳細画面|
|---|---|
|![map1-2](https://user-images.githubusercontent.com/67915047/158372178-f114d3a2-51a9-4719-8618-ad869ae6a670.jpg)|![map3](https://user-images.githubusercontent.com/67915047/158097271-b1fca94e-6d1a-4604-98f3-7b73a28faa05.jpg)|

<!--
目的: googlemapのような情報の蓄積 Twitterのような呟きではない

苦労したこと

導入、環境構築: これが一番苦労した
- 1. docker ファイル名変えるとブラウザでアクセスできなくなった
- 2. devise
- 3. rspec System.spec
- その他. cicd, bootstrap_webpack

フロントエンド
- footerナビ
  - レスポンシブ スマホでは下端に固定
  - アイコンの色を動的に変える
- 通知マーク➓ (header/footer)別で大きさ調整 position: relative
- 一覧のグリッドレイアウト Bootstrap_row col (home, users/show)

バックエンド
- 基本ロジック MVC
  - フォーム送信のpath 作成・削除 (routes, posts/show, comments/comment)

心がけたこと
- わからないことをこまめにメモして1つ1つ課題を潰していく
  - 1つ潰しても関連する課題が相乗的に増えていく自然の摂理
- 詰まったり挫折したら一旦放置してWebページを眺める
- フロントとバックエンドの両立の難しさ 手が回らない
  - <div>構成の知識や方法が知らない → Yotube, githubを参考
- seeds DRYにした
  - (post/comment) 3次元配列にする
  - 通知 (M)_メソッド活用 (follow, like, comment)

-->

## 実装機能

### ユーザー関連
* ユーザー登録、編集
<!-- 理解不十分 -->
* ログイン devise
* フォロー ajax

### スポット関連
* スポット一覧画面
  <!-- 複数表示 gon: JSにインスタンス変数を入れる -->
  <!-- 吹き出しの調査に苦悩 setContent -->
  * 地図上にマーカーを表示
  * ストリートビューを表示
* スポット詳細画面
  <!-- APIを叩く Post(M) -->
  * 住所の表示
  <!-- JavaScript -->
  * 口コミの投稿

### その他
* いいね通知
* ページネーション kaminari

## 使用技術
* フロントエンド
  * HTML/CSS/Sass/JavaScript
  * Slim
  <!-- slimによるコード量削減 -->
  * Bootstrap 4.5.3
  <!-- webpackにした為、読み込み遅くなった -->
  * jQuery 3.6.0
* バックエンド
  * Ruby 2.6.5
  * Rails 6.1.4
  <!-- 地図を表示 -->
  * Maps JavaScript API
  <!-- 高精度で緯度経度を算出 -->
  <!-- * Geocoding API -->
  <!-- ストリートビュー -->
  <!-- * Street View Static API -->
* インフラ
  <!-- 理解不十分 buildに10分も時間がかかる -->
  * Docker 20.10.12
  * docker-compose 2.2.3
  <!-- * Puma -->
  * MySQL 8.0
  * RSpec 3.10
    <!-- 全然手をつけられず -->
    <!-- * System spec -->
    <!-- * Request spec -->
  <!-- プルリクエスト -->
  * CircleCI
  * Heroku 7.59.4
* その他
  * Visual Studio Code
  * Git, Github
  <!-- * drawio -->

## 今後の課題
* スポット詳細画面
  - 住所を正しい変換
  - 住所の日本語化
* サンプルデータのスポット名やコメントを細かく書く
* ビューに家が映らないようにする

<!-- 参考
- メルカリ, インスタ, googlemap, amazon
- その他
-->