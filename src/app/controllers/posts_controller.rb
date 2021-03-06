class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :new]
  # 投稿のない詳細画面は表示できない
  before_action :correct_post,  only: :show
  # 自分以外のユーザーの投稿は削除できない
  before_action :correct_user,  only: :destroy

  # 投稿詳細
  def show
    # @post
    # map JS用
    gon.post = @post
    # 投稿に対するレビュー集
    @reviews = @post.reviews
    # レビューを新規作成
    if user_signed_in?
      @review = current_user.reviews.build
    else
      @review = @post.user.reviews.build
    end
  end

  # 投稿フォーム
  def new
    @post = current_user.posts.build
  end

  # 投稿する
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url, notice: 'スポット情報が追加されました'
    else
      # (shared/feed)
      # @feed_items = current_user.feed.page(params[:page]).per(10)
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
    params.require(:post).permit(
      :content,
      :address,
      :spot_quality, # radio
      :checkbox, spot_type: []
    )
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
