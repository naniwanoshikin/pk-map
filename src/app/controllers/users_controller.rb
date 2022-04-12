class UsersController < ApplicationController
  # ログインを要求
  before_action :authenticate_user!, only: [:destroy, :following, :followers]
  before_action :correct_user, only: [:show, :show_reviews]
  before_action :admin_user,   only: :destroy

  def show
    # @user
    @posts = @user.posts.page(params[:page]).per(6) # 13

    # pagination ajax
    respond_to do |format|
      format.html
      format.js
    end
  end

  # レビュー一覧
  def show_reviews
    # @user
    # @userのレビュー集
    @user_review_posts = @user.review_posts.page(params[:page]).per(4)
  end

  def index
    @users = User.page(params[:page]).per(10)
    # pagination
    respond_to do |format|
      format.html
      format.js
    end
  end

  # 管理者のみ
  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url, alert: "User deleted"
  end

  # 一覧
  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(10)
    render 'show_follow' # (users/show_follow)_共用
  end
  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(10)
    render 'show_follow'
  end

  private

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  # 正しいユーザーを要求
  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to root_url if @user.nil?
  end

end
