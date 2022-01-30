FROM ruby:2.7

# Herokuデプロイ時につける
# ENV RAILS_ENV=production

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

WORKDIR /app
COPY ./src /app
# Ruby関連のライブラリのインストール
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

# Herokuデプロイ時につける
# COPY start.sh /start.sh
# RUN chmod 744 /start.sh
# CMD ["sh", "/start.sh"]