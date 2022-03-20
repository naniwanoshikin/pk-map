# PKmap
```
息抜きに地元で運動できる場所を探しませんか。
公園や鉄棒など人気のスポットを紹介するサービスです。
```

## 公開ページ
[こちら](https://pk-map.herokuapp.com/)の画面からゲストログインできます。

|一覧画面|詳細画面|
|---|---|
|![map1-2](https://user-images.githubusercontent.com/67915047/158372178-f114d3a2-51a9-4719-8618-ad869ae6a670.jpg)|![map2-2](https://user-images.githubusercontent.com/67915047/159012821-92dee965-7d5c-4892-b2d0-cbc16d7b5c10.jpg)|

<!--
目的: googlemapのような情報の蓄積 Twitterのような呟きではない

苦労したこと

導入、環境構築: 最も苦労した 見えない部分を扱う怖さ
- 0. mac PC
  - iCloudって何者？急に雲マークが出てきて怖い
    - 消したはずの不要なファイルが再生成される
      - 無駄なCSSが生成され、機能しなくなった可能性
      - 無駄なDBが生成され、機能しなくなった可能性 migrateできない問題
    - 移動したはずのファイルが移動元にも無駄に生成されている
    - 挫折理由の大半はここ
- 1. docker 理解不十分
  - 起動停止の手間がかかる
    - buildに10分も時間がかかる
    - 突然のエラー
      - webコンテナ停止できなくなった
  - localhostにアクセスできなくなった ファイル名変えたせい？
- 2. bootstrap_webpack
  - JS, CSS のコンパイルが急に遅くなる
- 3. rspec System.spec
  - 全然手をつけられず
- 4. devise
  - 理解不十分
- 5. cicd, maps api: まだいい意味での苦労

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
* ログイン devise
* フォロー ajax

### スポット関連
* 一覧画面
  <!-- 複数表示 gon: JSにインスタンス変数を入れる -->
  <!-- 吹き出し setContent -->
  * マーカーの表示
  * ストリートビューの表示
* 詳細画面
  <!-- APIを叩く Post(M) -->
  * 住所の表示
  <!-- JavaScript, (comments/destroy)_ajax -->
  * 口コミの投稿

### その他
* いいね通知
* ページネーション kaminari

## 使用技術
* フロントエンド
  * HTML/CSS/Sass/JavaScript
  <!-- slimによるコード量削減 -->
  * Slim
  * webpack
  * Bootstrap 4.5.3
  <!-- ajax -->
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
  * Docker 20.10.12
  * docker-compose 2.2.3
  <!-- * Puma -->
  * MySQL 8.0
  * RSpec 3.10
    <!-- * System spec -->
    <!-- * Request spec -->
  * CircleCI
  * Heroku 7.59.4
* その他
  * Visual Studio Code
  * Git, Github
  <!-- インフラ構成図 -->
  <!-- * drawio -->

## 今後の課題
* 詳細画面
  - 住所の適切な変換
  - 住所の日本語化
* ビューに家が映らないようにする

<!-- 参考
フロントエンド
- メルカリ, インスタ, その他
バックエンド
- googlemap, amazon

-->