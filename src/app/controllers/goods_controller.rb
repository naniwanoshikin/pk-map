class GoodsController < ApplicationController
  before_action :authenticate_user!

  # 高評価する
  def create
    @comment = Comment.find(params[:comment])
    # @commentを高評価する
    current_user.good(@comment)
    # @comment.userに通知する
    current_user.notify_to_good!(@comment)
    # 既に低評価していれば低評価を解除
    if Bad.find_by(user_id: current_user.id, comment_id: @comment.id)
      current_user.unbad(@comment)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  # 高評価を解除
  def destroy
    @comment = Good.find(params[:id]).comment
    current_user.ungood(@comment)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
