# PKmap
```
息抜きに運動できる所を探しませんか。
人気のスポットを紹介するサービスです。
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
  <!-- (map_home(C).js) -->
  * Googleマップ  ピン 吹き出し
  * ストリートビュー
* 詳細画面
  <!-- (map_show(C).js) -->
  <!-- * 国内の住所の抽出 -->
  * モーダル画面
  * レビューの投稿/削除 ajax

### その他
* フラッシュ Stimulus化
* ページネーション kaminari
* フォロー通知

## 使用技術
### フロントエンド
<!-- * Slim -->
* HTML/CSS/Sass
* Bootstrap 5.3.8
* **スクリプト**: JavaScript / jQuery 3.6.0
* **フレームワーク**: Stimulus
* **ビルドツール**: webpack
* **外部API**: Maps JavaScript API (Google Maps)
<!-- drawer.js -->
<!-- ajax, ドロップダウン, flash[x], ローディング -->
<!-- 高精度で緯度経度を算出 -->
<!-- * Geocoding API -->
<!-- ストリートビュー -->
<!-- * Street View Static API -->
### バックエンド
* **言語**: Ruby 3.3.13
* **フレームワーク**: Ruby on Rails 7.2.4
* **認証**: Devise (5.0.4)
* **テスト**: RSpec 6.1.5
    <!-- * System spec -->
    <!-- * Request spec -->
### データベース & インフラ
* **データベース**: PostgreSQL 17 / Neon (Serverless PostgreSQL)
* **開発環境**: Docker 20.10.17 / docker-compose 2.3.3
* **本番環境**: Render (Docker Web Service)
* **バージョン管理**: Git / GitHub
  <!-- * CircleCI -->
  <!-- * Heroku 7.60.2 -->
<!-- * その他 -->
  <!-- * Visual Studio Code -->
  <!-- インフラ構成図 -->
  <!-- * drawio -->
  <!-- ファビコン -->
  <!-- * Adobe Fresco -->

## 今後の課題
* jQuery 廃止
* 非推奨警告の修正

|  | 旧 | 今ここ | 将来 |
| :--- | :--- | :--- | :--- |
| **Ruby** | 3.1.6 | **3.3.13** | 3.4  |
| **Rails** | 6.1.4 | **7.2.4** | 8.0 |
| **Bootstrap** | 4.6.1 | **5.3.8** | - |
| **本番環境** | heroku | Render | AWS (ECS)  |
<!-- | **Rspec** | 3.10 | 6.1.5 | 7.x  | -->
