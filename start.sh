#!/bin/sh

export RAILS_ENV=${RAILS_ENV:-development}
# export RUBYOPT="-W0"  # 全ての警告を抑制

# 本番環境の時だけ実行
if [ "${RAILS_ENV}" = "production" ]
then
  echo "=== 本番のみマイグレーション実行するお ==="
  bundle exec rails db:migrate
fi

# server.pid 削除 （Docker 再起動時のエラー防止）
# 万が一ファイルがなくても、エラーを無視して次に進む
rm -f tmp/pids/server.pid

# 開発環境のビルド監視
if [ "${RAILS_ENV}" = "development" ]
then
  echo "=== 開発環境：Webpackのファイル自動監視（--watch）を裏で起動するお ==="
  # 「&」をつけることで、バックグラウンドで実行
  yarn build --watch &
fi

# サーバ起動
bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}
