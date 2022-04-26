FROM ruby:3.0.4

# デプロイ時につける: testができなくなる + SSL化される
ENV RAILS_ENV=production

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn mariadb-client
# DBコンソール使う場合: mariadb-client

WORKDIR /app
COPY ./src /app
# Ruby関連のライブラリのインストール
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install
  # bundle install しないとwebコンテナが起動しない

COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]
