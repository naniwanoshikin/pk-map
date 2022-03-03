class PostsController < ApplicationController
  before_action :authenticate_user!,
  only: [:create, :destroy, :new]
  # 投稿のない詳細画面は表示しない
  before_action :correct_post,       only: :show
  # 自分以外のユーザーの投稿は削除できない
  before_action :correct_user,       only: :destroy


  # 投稿詳細
  def show
    # @post
  end

  # 投稿フォーム
  def new
    @post = current_user.posts.build # (shared/_post_form)
  end

  # 投稿する
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url, notice: '投稿しました'
    else
      # (shared/feed)
      @feed_items = current_user.feed.page(params[:page]).per(10)
      render 'posts/new'
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    @post.destroy
    redirect_to request.referrer || root_url, alert: '投稿を削除しました'
  end

  private

  def post_params # create
    params.require(:post).permit(:content)
  end

  def correct_post # show
    @post = Post.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end

  def correct_user # destroy
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
