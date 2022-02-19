# 5 コマンド省略

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
	docker-compose exec web bundle exec --rm web bash
# mysql起動: password入力
sql:
	docker-compose exec web rails db
# ルーティング
route:
	docker-compose exec web rails routes
routeu:
	docker-compose exec web rails routes | grep users
routes:
	docker-compose exec web rails routes | grep sessions
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
status:
	docker-compose exec web rails db:migrate:status
seed:
	docker-compose exec web rails db:seed

dev:
	docker-compose exec web rails db:environment:set RAILS_ENV=development

