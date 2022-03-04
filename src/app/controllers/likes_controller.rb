class LikesController < ApplicationController
  before_action :authenticate_user!

  # いいねする
  def create
    @post = Post.find(params[:post])
    current_user.like(@post)
    # current_userが@post.userに通知を送る
    @post.create_notification_like!(current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  # いいね解除
  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
