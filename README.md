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
サーバーレスDB（Neon）とのネットワーク往復回数（RTT）および転送データ量を削減するため、Bullet によるクエリ監視のもと全主要画面のチューニングを実施しました。

* **N+1問題の解消 & Eager Loading**: `includes` の適切な適用や、一覧画面でのフォロー関係の一括配列先読みにより、無駄な個別クエリを排除。
* **サブクエリ化によるSQL高速化**: ホームフィードの多重 `LEFT OUTER JOIN` ＋ `DISTINCT` をサブクエリへ改善し、投稿取得SQLの実行時間を **57.3ms ➔ 1.8ms（約32倍速）** に短縮。
* **一括処理・キャッシュ活用**: `counter_cache` の導入、kaminari の `.without_count` 活用、さらに `insert_all` / `delete_all` / `delete_by` による一括DB操作でデータ増大時もクエリ数が増えない設計を実現。
  * ユーザー一覧（`users/index`）: **16クエリ ➔ 4クエリ（75%削減）**
  * ユーザー詳細（`users/show`）: **19クエリ ➔ 5クエリ（約74%削減）**
  * フォロー・フォロワー一覧（`following` / `followers`）: **19クエリ ➔ 6クエリ（約68%削減）**
  * レビュー削除（`reviews/destroy`）: **12クエリ ➔ 9クエリ / 完了時間 1850ms ➔ 319ms（約5.8倍速）**
* **モダン化・技術的負債の解消**: Ruby 2.7 ➔ 3.4、Rails 6.0 ➔ 8.0 への段階的アップグレード、および jQuery / Webpacker / Slim の廃止（Turbo / Stimulus / ERB へ移行）を実施。 -->

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
* 通知 (フォロー・レビュー・高評価)
* クエリ最適化 N+1対策 （Bullet）

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
| 環境 | 初期 | 現在 | 今後 |
| :--- | :--- | :--- | :--- |
| **Rails** | 6.0.4 | **8.0.5** | 8.1 |
| **Ruby** | 2.7.6 | **3.4.13** | - |
| **Bootstrap** | 3.4.1, 4.6.1 | **5.3.8** | - |
| **JS** | jQuery 3.6.0| **Stimulus** | -  |
| **ビルド** | Webpacker | **webpack** | -  |
| **テンプレート** | slim | **ERB** | -  |
| **本番環境** | heroku | Render + Neon | AWS (ECS)  |
<!-- | **Rspec** | 3.10 | 6.1.5 | 7.x  | -->

## 今後の課題
* ホームフィード の通信量・API課金削減
* Users(C) Session(C)??? _create/destroy アクションのクエリ最適化
* Rails バージョン上げ 非推奨警告の修正
<!-- * 地図 ボタン機能の実装 -->
