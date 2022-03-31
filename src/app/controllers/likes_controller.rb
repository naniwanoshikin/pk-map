class LikesController < ApplicationController
  before_action :authenticate_user!

  # いいねする
  def create
    @comment = Comment.find(params[:comment])
    # @commentをいいねする
    current_user.like(@comment)
    # @comment.userに通知する
    current_user.notify_to_like!(@comment)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  # いいね解除
  def destroy
    @comment = Like.find(params[:id]).comment
    current_user.unlike(@comment)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
