FROM ruby:3.0.4

# ENV RAILS_ENV=production (これはRender 側で渡す)

# Node / Yarn インストール（軽量に）
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor \
    | tee /usr/share/keyrings/yarn-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" \
    | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn

WORKDIR /app
COPY ./src /app

# Production のみ bundle install
RUN bundle config set without 'development test' \
  && bundle install
# bundle install しないとwebコンテナが起動しない

COPY start.sh /start.sh
RUN chmod +x /start.sh
# Web サーバー起動は start.sh に任せる
CMD ["sh", "/start.sh"]
