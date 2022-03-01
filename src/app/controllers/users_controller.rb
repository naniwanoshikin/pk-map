class UsersController < ApplicationController
  # ログインを要求
  before_action :authenticate_user!, only: [:show, :destroy, :following, :followers]
  before_action :admin_user,     only: :destroy

  def show # 7
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10) # 13

    # pagination ajax
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index # 10
    @users = User.page(params[:page]).per(15)
    # pagination
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # 一覧
  def following # 14.2.3
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(10)
    render 'show_follow' # (users/show_follow)
  end
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(10)
    render 'show_follow' # 共用
  end

  private

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
