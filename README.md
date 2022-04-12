# PKmap
```
息抜きに運動できる所を探しませんか。
公園や鉄棒など人気のスポットを紹介するサービスです。
```

## 公開ページ
ページは[こちら](https://pk-map.herokuapp.com/)です。<br>
※表示まで時間がかかります。80秒程。<br>
サーバーが停止していたり、Application errorになる場合はリロードをお願いします。

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
  * 住所の表示
  <!-- JavaScript, (comments/destroy)_ajax -->
  * レビュー、評価

### その他
* フォロー通知
* ページネーション kaminari

## 使用技術
* フロントエンド
  * HTML/CSS/Sass
  <!-- slimによるコード量削減 -->
  * Slim
  * JavaScript
  * webpack
    * Bootstrap 4.6.1
    <!-- ajax, ドロップダウン, flash[x], ローディング -->
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
  * Docker 20.10.13
  * docker-compose 2.3.3
  <!-- * Puma -->
  * MySQL 8.0
  * RSpec 3.10
    <!-- * System spec -->
    <!-- * Request spec -->
  * CircleCI
  * Heroku 7.60.1
* その他
  <!-- * Visual Studio Code -->
  * Git, Github
  <!-- インフラ構成図 -->
  <!-- * drawio -->

## 今後の課題
* 詳細画面
  - 住所の適切な変換
  - 住所の日本語化
* ラジオボタン検索
* ビューに家が映らないようにする
