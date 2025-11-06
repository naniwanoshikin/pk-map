#!/bin/sh

export RAILS_ENV=${RAILS_ENV:-development}

# 本番環境の時だけ実行
if [ "${RAILS_ENV}" = "production" ]
then
  bundle exec rails assets:precompile
  bundle exec rails db:migrate # Render側に入れると有料になる為こちらに入れた
fi

# server.pid 削除してから起動（Docker 再起動時のエラー防止）
rm -f tmp/pids/server.pid

# サーバ起動
bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}
