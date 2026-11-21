# コンテナのポート確認
ps:
	docker-compose ps
# ログ
log:
	docker-compose logs
# 起動 だいぶ時間かかる時がある
build:
	docker-compose up --build -d
up:
	docker-compose up -d
# webpackを更新したらこれだけでいい
re:
	docker-compose restart
# 停止
stop:
	docker-compose stop
# 削除
down:
	docker-compose down
# 全削除
pr:
	docker system prune

# シェル 出る時: exit
bash:
	docker-compose run --rm web bash
# コンソール
c:
	docker-compose exec web rails c
cs:
	docker-compose exec web rails c --sandbox
# mysql起動
db:
	docker-compose exec web rails db

# ルーティング
route:
	docker-compose exec web rails routes
routeu:
	docker-compose exec web rails routes | grep users
routep:
	docker-compose exec web rails routes | grep posts

# migrate
m:
	docker-compose exec web rails db:migrate
# データの中身（テーブル）を削除
mr:
	docker-compose exec web rails db:schema:load
md:
	docker-compose exec web rails db:migrate:down VERSION=20220309035728
ms:
	docker-compose exec web rails db:migrate:status
seed:
	docker-compose exec web rails db:seed

# 本番用seed 未実施
productseed:
	docker-compose run --rm -e RAILS_ENV=production -e DATABASE_URL="postgresql://neondb_owner:npg_TVN0F5fPyUSk@ep-quiet-grass-a18326s2.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require" web bundle exec rails db:seed

# Rubocop
rub:
	docker-compose exec web bundle exec rubocop
rub1:
	docker-compose exec web bundle exec rubocop db/seeds.rb
rub2:
	docker-compose exec web bundle exec rubocop app/controllers/*

# Rspec
rspec:
	docker-compose exec web bundle exec rspec
rspecr:
	docker-compose exec web bundle exec rspec spec/requests/users_spec.rb
rspecs:
	docker-compose exec web bundle exec rspec spec/system
rspecm:
	docker-compose exec web bundle exec rspec spec/models
rspech:
	docker-compose exec web bundle exec rspec spec/helpers


# -----------------------------------------------
# プッシュ
p:
	git add .
	git commit -m "Add GitHub Actions workflow for RuboCop"
	git push origin map
# ▶︎GitHub上で手動操作 Pullrequ & マージ
me:
	git co main
	git merge map
	git branch -d map
	git switch -c map
# ▶︎:wq 完了

# -----------------------------------------------
# slim をerbに変換 src/は消す slimは手動で削除せよ (バックアップ不可)
slim:
	docker-compose exec web bundle exec slimrb -e app/views/home_pages/aa.html.erb app/views/home_pages/aa.html.slim -d
