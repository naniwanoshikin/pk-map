#!/bin/sh

# 途中でエラーが出たら止まる
set -o errexit

export RAILS_ENV=${RAILS_ENV:-development}
export RUBYOPT="-W0"  # 全ての警告を抑制（追加）
# export NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=460"  # Webpack 4とNode.js 18の互換性 / メモリ制限


# 本番環境の時だけ実行
if [ "${RAILS_ENV}" = "production" ]
then
  echo "=== 今からstart.sh production のみ ==="
  # yarn install --check-files # Renderでエラー メモリ不足
  # bundle exec rails webpacker:compile # Renderでエラー メモリ不足
  # bundle exec rails assets:precompile # Renderでエラー
  echo "=== 今からマイグレーション実行するお ==="
  bundle exec rails db:migrate
fi

# server.pid 削除 （Docker 再起動時のエラー防止）
rm -f tmp/pids/server.pid

# サーバ起動
bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}
