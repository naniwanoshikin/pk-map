class UsersController < ApplicationController
  # ログインを要求
  before_action :authenticate_user!
  before_action :admin_user,     only: :destroy

  def show # 7
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10) # 13
  end

  def index # 10
    @users = User.page(params[:page]).per(15)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
