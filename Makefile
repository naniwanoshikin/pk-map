# 5 省略コマンド

# 確認
ps:
	docker-compose ps
# ログ
log:
	docker-compose logs
# 起動
build:
	docker-compose up --build -d
up:
	docker-compose up -d
# 停止
stop:
	docker-compose stop
# 全削除
prune:
	docker system prune
# 削除
down:
	docker-compose down
# コンソール ⇄ cntrl + d
c:
	docker-compose exec web rails c
cs:
	docker-compose exec web rails c --sandbox
# シェル
bash:
	docker-compose run --rm web bash
# mysql起動: password入力
db:
	docker-compose exec web rails db
# ルーティング
route:
	docker-compose exec web rails routes
routeu:
	docker-compose exec web rails routes | grep users
routes:
	docker-compose exec web rails routes | grep sessions
routep:
	docker-compose exec web rails routes | grep posts
# Rubocop
rbo:
	docker-compose exec web bundle exec rubocop --require rubocop-airbnb
# Rspec
r:
	docker-compose exec web bundle exec rspec
rr:
	docker-compose exec web bundle exec rspec spec/requests
rs:
	docker-compose exec web bundle exec rspec spec/system
rse:
	docker-compose exec web bundle exec rspec spec/system/users_edit_spec.rb
rm:
	docker-compose exec web bundle exec rspec spec/models
rh:
	docker-compose exec web bundle exec rspec spec/helpers

# migrate
mg:
	docker-compose exec web rails db:migrate
reset:
	docker-compose exec web rails db:migrate:reset
mgs:
	docker-compose exec web rails db:migrate:status
mgd:
	docker-compose exec web rails db:migrate:down VERSION=20220309035728
seed:
	docker-compose exec web rails db:seed


# slim に変換 ファイル指定 src/は消す erbは削除(バックアップ不可)
slim:
	docker-compose exec web bundle exec erb2slim app/views/static_pages/aa.html.erb app/views/static_pages/aa.html.slim -d
# 直前のコミットに戻る 特定のファイル
co:
	git checkout src/app/assets/stylesheets/comments.scss
# 特定の相対パス, 特定の拡張子のファイルを削除
filed:
	find src/app/views -type f -name "*.slim" -delete


# 生成
g:
	docker-compose exec web rails g model Comment content:string user:references post:references
# 削除
d:
	docker-compose exec web rails d model Comment

in:
	docker-compose exec web rails webpacker:install
# コンパイル
w:
	docker-compose exec web rails webpacker:compile
