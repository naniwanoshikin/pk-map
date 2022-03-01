class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # フォローされるユーザー
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    # current_userが@userに通知を送る
    @user.create_notification_follow!(current_user)

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
