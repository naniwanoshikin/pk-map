# PKmap
```
息抜きに運動できる所を探しませんか。
公園や鉄棒など人気のスポットを紹介するサービスです。
```

## 公開ページ
[公開ページ](https://pkmap.onrender.com)です。表示にやや時間がかかります。<br>

|スポット一覧|スポット詳細|
|---|---|
|![map1-2](https://user-images.githubusercontent.com/67915047/158372178-f114d3a2-51a9-4719-8618-ad869ae6a670.jpg)|![map2-2](https://user-images.githubusercontent.com/67915047/159012821-92dee965-7d5c-4892-b2d0-cbc16d7b5c10.jpg)|


## 実装機能

### ユーザー関連
* ユーザー登録、編集
* ログイン devise
* フォロー ajax

### スポット関連
* 一覧画面
  <!-- 複数表示: gon -->
  <!-- 吹き出し: setContent -->
  * マーカーの表示
  * ストリートビューの表示
* 詳細画面
  <!-- APIを叩く Post(M) -->
  * 日本国内の住所の抽出
  * Twitterシェア
  <!-- JavaScript, (comments/destroy)_ajax -->
  * 口コミ、評価

### その他
* フォロー通知
* ページネーション kaminari

## 使用技術
* フロントエンド
  * HTML/CSS/Sass
  * Slim
  * JavaScript
  <!-- drawer.js -->
  * webpack
    * Bootstrap 4.6.1
    <!-- ajax, ドロップダウン, flash[x], ローディング -->
    * jQuery 3.6.0
* バックエンド
  * Ruby 3.1.6
  * Rails 6.1.4
  <!-- 地図を表示 -->
  * Maps JavaScript API
  <!-- 高精度で緯度経度を算出 -->
  <!-- * Geocoding API -->
  <!-- ストリートビュー -->
  <!-- * Street View Static API -->
* インフラ 開発環境
  * Docker 20.10.17
  * docker-compose 2.3.3
  * MySQL 8.0
  * RSpec 3.10
    <!-- * System spec -->
    <!-- * Request spec -->
  * CircleCI
* インフラ 本番環境
  * Render (Docker Web Service)
  * Neon (サーバーレス PostgreSQL)
  <!-- * Heroku 7.60.2 -->
* その他
  <!-- * Visual Studio Code -->
  * Git, Github
  <!-- インフラ構成図 -->
  <!-- * drawio -->
  <!-- ファビコン -->
  <!-- * Adobe Fresco -->

## 今後の課題
* Rails7への移行
* テストの記述

<!-- * SPA構築 -->
