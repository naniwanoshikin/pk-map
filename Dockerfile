FROM ruby:3.1.6

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

# 環境変数に応じて bundle を切り替える！
ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}


# 本番のみ dev/test を除外
RUN if [ "$RAILS_ENV" = "production" ] ; then \
      bundle config set without 'development test' ; \
    fi && \
    bundle install
# bundle install しないとwebコンテナが起動しない

# 本番のみ アセットビルド start.sh で記述するとエラー出た為
RUN if [ "$RAILS_ENV" = "production" ] ; then \
      yarn install --check-files && \
      bundle exec rails webpacker:compile && \
      bundle exec rails assets:precompile ; \
    fi

COPY start.sh /start.sh
# 実行権限
RUN chmod +x /start.sh
# Web サーバー起動は start.sh に任せる
CMD ["sh", "/start.sh"]
