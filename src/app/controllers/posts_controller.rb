class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :new]
  before_action :set_post_and_correct_post,  only: :show
  before_action :set_user_post_and_correct_user,  only: :destroy

  # 投稿詳細
  def show
    # @post 下記
    # 投稿に対するレビュー集
    @reviews = @post.reviews
    # レビューを新規作成
    if user_signed_in?
      @review = current_user.reviews.build
    else
      @review = Review.new
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
      # Rails 7(Turbo)
      render :new, status: :unprocessable_entity # 422エラー
    end
  end

  def destroy
    # @post 下記
    @post.destroy
    redirect_to request.referrer || root_url, alert: '投稿を削除しました', status: :see_other
  end

  private

  def post_params # create
    params.require(:post).permit(
      :content,
      :address,
      :spot_quality, # radio
      spot_type: [] # checkbox
    )
  end

  # 投稿のない詳細画面は表示できない show
  def set_post_and_correct_post
    @post = Post.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end

  # 自分以外のユーザーの投稿は削除できない destroy
  def set_user_post_and_correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
