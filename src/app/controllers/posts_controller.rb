class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  # 投稿する
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page]).per(10)
      render 'static_pages/home'
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    @post.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
