#!/bin/sh

# 途中でエラーが出たら止まる
set -o errexit

export RAILS_ENV=${RAILS_ENV:-development}
# export NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=460"  # Webpack 4とNode.js 18の互換性 / メモリ制限


# 本番環境の時だけ実行
if [ "${RAILS_ENV}" = "production" ]
then
  echo "=== start.sh production なう zzz ==="
  # yarn install --check-files # Renderでエラー メモリ不足
  bundle exec rails webpacker:compile # Renderでエラー メモリ不足
  # bundle exec rails assets:precompile # Renderでエラー
  bundle exec rails db:migrate # Render側に入れると有料になる為こちらに入れた
fi

# server.pid 削除 （Docker 再起動時のエラー防止）
rm -f tmp/pids/server.pid

# サーバ起動
bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}
