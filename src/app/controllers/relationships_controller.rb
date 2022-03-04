class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # フォローされるユーザー
    @user = User.find(params[:followed_id])
    # @userをフォロー
    current_user.follow(@user)
    # @userに通知
    current_user.notify_to_follow!(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js # Ajaxリクエスト
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
