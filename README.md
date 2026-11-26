[![RuboCop](https://github.com/naniwanoshikin/pk-map/actions/workflows/rubocop.yml/badge.svg)](https://github.com/naniwanoshikin/pk-map/actions/workflows/rubocop.yml)

# PKmap
```
外で運動できる所を探しませんか。
人気のスポットを紹介するサービスです。
```

## 公開ページ
[公開ページ](https://pkmap.onrender.com)
※無料プランのため初回起動にやや時間がかかります。<br>

|スポット一覧|スポット詳細|
| :---: | :---: |
|![map1-2](https://user-images.githubusercontent.com/67915047/158372178-f114d3a2-51a9-4719-8618-ad869ae6a670.jpg)|![map2-2](https://user-images.githubusercontent.com/67915047/159012821-92dee965-7d5c-4892-b2d0-cbc16d7b5c10.jpg)|

<!-- ## パフォーマンス・運用コスト最適化の取り組み
サーバーレスDB（Neon）との通信回数削減およびレスポンス高速化のため、Bullet によるクエリ監視のもと継続的なチューニングを実施しました。

* **N+1問題の解消 & Eager Loading**: `includes` / `preload` の適切な使い分けや、一覧画面でのフォロー状態の一括先読みにより、無駄なSQL発行を徹底排除。
* **キャッシュ・集計最適化**: `counter_cache` の導入、メモリ上での配列計算、kaminari の `.without_count` 活用により、主要画面のSQLクエリ数を大幅に削減。
  * ユーザー詳細（`users/show`）: **19クエリ → 5クエリ（約74%削減）**
  * レビュー一覧（`users/show_reviews`）: **18クエリ → 6クエリ（約67%削減）**
  * フォロー・フォロワー一覧（`users/following`, `followers`）: **19クエリ → 6クエリ（約68%削減）**
  * ユーザー一覧（`users/index`）: **16クエリ → 4クエリ（75%削減）**
* **モダン化・技術的負債の解消**: Ruby 2.7 → 3.4、Rails 6.0 → 8.0 への段階的アップグレード、および jQuery / Webpacker / Slim の廃止（Turbo / Stimulus / ERB へ移行）を実施。 -->

---
## 実装機能

### ユーザー関連
* ユーザー登録・編集 Devise
* ゲストログイン
* フォロー / フォロワー

### スポット関連
* **一覧画面**
  * 地図 (ピン/吹き出し)
  * 検索 オートコンプリート （Places API New）
  * ストリートビュー （Street View Static API）
* **詳細画面**
  <!-- * 国内の住所の抽出 -->
  * モーダル画面の開閉 Stimulus
  * レビューの投稿/削除 (非同期)

### その他
* ドロワー Bootstrap
* フラッシュ Stimulus
* ページネーション （kaminari + Turbo Streams）
* 通知 (フォロー・レビュー・いいね)
* N+1問題 クエリ最適化 Bullet

---

## 使用技術
### フロントエンド
* **マークアップ / CSS**: ERB / Sass / Bootstrap 5.3.8
* **言語**: JavaScript
* **フレームワーク**: Stimulus
* **ビルドツール**: webpack
* **外部API**: Maps JavaScript API / Places API (New) / Street View Static API

### バックエンド
* **言語**: Ruby 3.4.13
* **フレームワーク**: Ruby on Rails 8.0.5.2
* **認証**: Devise 5.0.4
* **外部API**: Google Geocoding API
* **静的解析**: RuboCop (rubocop-rails)
* **テスト**: RSpec 6.1.5
### データベース & インフラ
* **データベース**: PostgreSQL 17 / Neon (Serverless PostgreSQL)
* **開発環境**: Docker 20.10.17 / docker-compose 2.3.3
* **本番環境**: Render (Docker Web Service / Auto-Deploy)
* **バージョン管理 / CI**: Git / GitHub / GitHub Actions

<!-- * その他 -->
  <!-- * Visual Studio Code -->
  <!-- インフラ構成図 -->
  <!-- * drawio -->
  <!-- ファビコン -->
  <!-- * Adobe Fresco -->
  <!-- * System spec -->
  <!-- * Request spec -->

---

## バージョン移行履歴
| 環境 | 旧 | 現在 | 今後 |
| :--- | :--- | :--- | :--- |
| **Rails** | 6.0.4 | **8.0.5** | 8.1 |
| **Ruby** | 2.7.6 | **3.4.13** | - |
| **Bootstrap** | 3.4.1, 4.6.1 | **5.3.8** | - |
| **JS** | jQuery 3.6.0| **Stimulus** | -  |
| **ビルド** | Webpacker | **webpack** | -  |
| **テンプレート** | slim | **ERB** | -  |
| **本番環境** | heroku 7.60.2 | Render + Neon | AWS (ECS)  |
<!-- | **Rspec** | 3.10 | 6.1.5 | 7.x  | -->

## 今後の課題
* ホームフィード の通信量・API課金削減
* Rails バージョン上げ 非推奨警告の修正
<!-- * 地図 ボタン機能の実装 -->
