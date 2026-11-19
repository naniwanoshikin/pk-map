# PKmap
```
外で運動できる所を探しませんか。
人気のスポットを紹介するサービスです。
```

## 公開ページ
[公開ページ](https://pkmap.onrender.com)です。表示にやや時間がかかります。<br>

|スポット一覧|スポット詳細|
|---|---|
|![map1-2](https://user-images.githubusercontent.com/67915047/158372178-f114d3a2-51a9-4719-8618-ad869ae6a670.jpg)|![map2-2](https://user-images.githubusercontent.com/67915047/159012821-92dee965-7d5c-4892-b2d0-cbc16d7b5c10.jpg)|


## 実装機能

### ユーザー関連
* ユーザー登録、編集 Devise
* ゲストログイン
* フォロー

### スポット関連
* 一覧画面
  * 検索 オートコンプリート機能 Places API (New)
  * Googleマップ (ピン/吹き出し)
  * ストリートビュー
* 詳細画面
  <!-- * 国内の住所の抽出 -->
  * モーダル画面の開閉 Stimulus
  * レビューの投稿/削除 (非同期)

### その他
* ドロワー Bootstrap
* フラッシュ Stimulus
* ページネーション kaminari (非同期)
* 通知 (フォローなど)
<!-- ドロワー, ローディング, モーダルお片づけ -->
<!-- 高精度で緯度経度を算出 -->
<!-- * Geocoding API -->
<!-- * Street View Static API -->

## 使用技術
### フロントエンド
* HTML/CSS/Sass
* Bootstrap 5.3.8
* **スクリプト**: JavaScript
* **フレームワーク**: Stimulus
* **ビルドツール**: webpack
* **外部API**: Maps JavaScript API
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
<!-- * その他 -->
  <!-- * Visual Studio Code -->
  <!-- インフラ構成図 -->
  <!-- * drawio -->
  <!-- ファビコン -->
  <!-- * Adobe Fresco -->

## 今後の課題
* 非推奨警告の修正 / リファクタリング
* 地図 ボタン機能の実装

## コード廃止
* jQuery
* Slim


|  | 旧 | 今ここ | 将来 |
| :--- | :--- | :--- | :--- |
| **Ruby** | 2.7.6 | **3.3.13** | 3.4  |
| **Rails** | 6.0.4 | **7.2.4** | 8.0 |
| **Bootstrap** | 4.6.1 | **5.3.8** | - |
| **本番環境** | heroku 7.60.2 | Render | AWS (ECS)  |
<!-- | **jQuery** | 3.6.0 | **廃止** | - | -->
<!-- | **Rspec** | 3.10 | 6.1.5 | 7.x  | -->
