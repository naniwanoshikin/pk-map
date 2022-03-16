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
  - JSの読み込み時間がかかる...
- bootstrap 3.4.1 → 4.5.0 結局CDNで読み込んだ
  - CSSの読み込み時間がかかるようになった...

方針
- わからないことをメモして1つ1つ潰していった
感想
- フロントとバックエンドの両立の難しさ 手が回らない
- 課題を1つ潰しても関連する課題が相乗的に増えていく自然の摂理
- slimによるコード量削減がすごい

フロントエンド
- レスポンシブ スマホでは下端にfooterを固定
  - 表示ごとにアイコンの色を変える
- 通知マーク➓の(header/footer)別で大きさ調整 position: relative
- 一覧のグリッドレイアウト Bootstrap_row col (home, users/show)
- <div>構成の知識や方法が知らない → Yotube_githubを参考

バックエンド
- 地図の表示 gon: JSにインスタンス変数を入れる
  - Homeページ  ピンは複数 + 吹き出し + ストリートビュー
  - 詳細ページ  ピンは1つ
    - APIを叩いて住所を算定
- 基本ロジック MVC
  - フォーム送信のpath 作成・削除 (routes, posts/show, comments/comment)
- seeds 極力DRYにした
  - (post/comment) 3次元配列にする
  - 通知 メソッド活用 (follow, like, comment)

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
|![map1-2](https://user-images.githubusercontent.com/67915047/158372178-f114d3a2-51a9-4719-8618-ad869ae6a670.jpg)|![map3](https://user-images.githubusercontent.com/67915047/158097271-b1fca94e-6d1a-4604-98f3-7b73a28faa05.jpg)|


## 実装機能

### ユーザー関連
* ユーザー登録、編集
* ログイン devise
* フォロー
* コメント一覧

### スポット関連
* 一覧画面
  * ピンをクリックすると詳細へ
  * ストリートビュー画像の表示
* 詳細画面
  <!-- APIを叩く -->
  * 住所算定
  <!-- Javascript -->
  * 星レビュー

### その他
* 通知: コメントなど
* 非同期 ajax: フォロー、いいねなど
* ページネーション kaminari

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
  <!-- * Geocoding API -->
  <!-- ストリートビュー -->
  <!-- * Street View Static API -->
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
* エラー修正
  * スポット名がヒットしないエラー
    * seedsのスポット名やコメントを細かく書く
    * 家映らないようにする
* スポット詳細画面
  - 住所を日本語化
