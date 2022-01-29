#!/bin/sh

# 本番環境の時だけ実行
if [ "${RAILS_ENV}" = "production" ]
then
  bundle exec rails assets:precompile
fi
# サーバ起動
bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0
