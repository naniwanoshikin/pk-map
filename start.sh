#!/bin/sh

# 本番環境の時だけ実行
if [ "${RAILS_ENV}" = "production" ]
then
  bundle exec rails assets:precompile
fi

# server.pid 削除してから起動（Docker 再起動時のエラー防止）
rm -f tmp/pids/server.pid

# サーバ起動
bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}
