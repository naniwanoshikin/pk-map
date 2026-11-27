# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # フォローされるユーザー
    @user = User.find(params.expect(:followed_id))
    # @userをフォロー
    relationship = current_user.follow(@user)
    # @userにフォロー通知
    current_user.notify_to_follow!(@user)

    @my_relationships = [relationship] # (users/follow_form)_SQL対策（DB再検索の防止）

    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  def destroy
    # 自分のフォロー関係に限定
    relationship = current_user.active_relationships.find(params.expect(:id))
    # フォロー相手のユーザー
    @user = relationship.followed
    relationship&.destroy

    @my_relationships = []

    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end
end
