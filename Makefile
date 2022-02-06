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
	docker-compose exec web rails console --sandbox
# Rspec
t:
	docker-compose exec web bundle exec rspec
tm:
	docker-compose exec web bundle exec rspec spec/models
tf:
	docker-compose exec web bundle exec rspec spec/features
# db:migrate
mg:
	docker-compose exec web rails db:migrate