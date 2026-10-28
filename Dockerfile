# 必要なNode.jsとYarnのバイナリを確保するステージ
FROM node:20.18.0-slim AS node-env

FROM ruby:3.1.6

# Node.jsイメージから node, npm, yarn を直接コピーして格納
COPY --from=node-env /usr/local/bin /usr/local/bin
COPY --from=node-env /usr/local/lib/node_modules /usr/local/lib/node_modules

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

# ここで初めてRailsの全ソースコードをコピー（これで2回目以降のデプロイが超高速に）
COPY ./src /app

# Railsのルート（/app）の直下で、必要な環境変数をすべて揃えてCSSをビルド
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
