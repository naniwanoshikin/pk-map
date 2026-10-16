FROM ruby:3.1.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor \
  | tee /usr/share/keyrings/yarn-archive-keyring.gpg > /dev/null \
  && echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" \
  | tee /etc/apt/sources.list.d/yarn.list \
  # Node / Yarn インストール
  # 【対策】OSパッケージを最新に更新
  && apt-get update -qq \
  && apt-get upgrade -y \
  && apt-get install -y nodejs yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 先にGemfileだけをコピー、bundle install をキャッシュさせる
COPY ./src/Gemfile ./src/Gemfile.lock /app/

# 環境変数に応じて bundle を切り替える
ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}

# bundler を lockfile のバージョンに揃える
RUN gem install bundler -v 2.2.33

# 本番のときのみ dev/test を除外
RUN if [ "$RAILS_ENV" = "production" ] ; then \
      bundle config set without 'development test' ; \
    fi && \
    bundle install
# bundle install しないとwebコンテナが起動しない

# ここで初めてRailsの全ソースコードをコピー（これで2回目以降のデプロイが超高速になる）
COPY ./src /app

# Railsのルート（/app）の直下で、必要な環境変数をすべて揃えてCSSをビルドする
RUN if [ "$RAILS_ENV" = "production" ] ; then \
      NODE_OPTIONS="--openssl-legacy-provider" \
      RAILS_ENV=production \
      SECRET_KEY_BASE=1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef \
      bundle exec rails assets:precompile ; \
    fi

COPY start.sh /start.sh
# 実行権限
RUN chmod +x /start.sh
# Web サーバー起動は start.sh に任せる
CMD ["sh", "/start.sh"]
