# frozen_string_literal: true

class UsersController < ApplicationController
  # ログインを要求
  before_action :authenticate_user!, only: %i[destroy following followers]
  before_action :set_user, only: %i[show show_reviews following followers]
  before_action :admin_user, only: :destroy

  # ユーザー一覧
  def index
    @users = User.page(params[:page]).per(12)
  end

  def show
    # @user 13
    # N+1問題対策 includes / without_count
    @posts = @user.posts.includes(:reviews).page(params[:page]).per(6).without_count

    respond_to do |format|
      format.html
      # ログイン後のリダイレクトに、非同期ページネーション(users/show.turbo_stream.erb)を優先されると、
      # #user_posts_listが存在せず、Turbo は「書き換える場所が見つからない！」と元の画面のままフリーズするため、
      # 「もっと見る」のときだけ非同期処理するよう分岐。
      format.turbo_stream if params[:page].present?
    end
  end

  # レビュー一覧
  def show_reviews
    # @user
    @user_review_posts = @user.review_posts # @userがレビューした投稿集
                              .joins(:reviews) # レビューの表を連結 日時を見れる様に
                              .select('posts.*, reviews.created_at AS reviewed_at') # 投稿データ+レビュー日時(reviewd_at)だけを選ぶ
                              .preload(:reviews, :user) # SQL減らす 一括で先読み
                              .unscope(:order) # 元の並び順をリセット
                              .order('reviews.created_at DESC') # レビュー順に並び替え
                              .page(params[:page]).per(6) # 6件ずつ小分け
                              .without_count # SQL減らす 「もっと見る」用の高速化
  end

  # フォロー/フォロワー一覧 共用
  def following
    @title = 'フォロー中'
    # @user
    @users = @user.following.page(params[:page]).per(7)
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー'
    # @user
    @users = @user.followers.page(params[:page]).per(7)
    render 'show_follow'
  end

  # ユーザー削除 管理者のみ
  def destroy
    User.find(params.expect(:id)).destroy
    redirect_to users_url, alert: 'ユーザーが削除されました', status: :see_other
  end

  private

  # 対象のユーザーが存在するか確認
  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to root_url if @user.nil?
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
