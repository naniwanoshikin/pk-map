class BadsController < ApplicationController
  before_action :authenticate_user!

  # 低評価する
  def create
    @comment = Comment.find(params[:comment])

    current_user.bad(@comment)


    # 高評価を解除
    if Good.find_by(user_id: current_user.id, comment_id: @comment.id)
      current_user.ungood(@comment)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  # 低評価を解除
  def destroy
    @comment = Bad.find(params[:id]).comment
    current_user.unbad(@comment)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
