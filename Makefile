# 5 コマンド省略

# 確認
ps:
	docker-compose ps
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
# ルーティング
routes:
	docker-compose exec web rails routes
routesu:
	docker-compose exec web rails routes | grep users
routess:
	docker-compose exec web rails routes | grep sessions
# Rspec
r:
	docker-compose exec web bundle exec rspec
rm:
	docker-compose exec web bundle exec rspec spec/models
rf:
	docker-compose exec web bundle exec rspec spec/features
rh:
	docker-compose exec web bundle exec rspec spec/helpers
rr:
	docker-compose exec web bundle exec rspec spec/requests
# Rubocop
rubo:
	docker-compose exec web bundle exec rubocop --require rubocop-airbnb
# migrate
mg:
	docker-compose exec web rails db:migrate
mgreset:
	docker-compose exec web rails db:migrate:reset
