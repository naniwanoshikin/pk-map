class UsersController < ApplicationController
  # ログインを要求
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def index # 10
    @users = User.page(params[:page]).per(15)
  end

end
