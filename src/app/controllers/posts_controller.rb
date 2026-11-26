# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy new]
  before_action :set_post, only: :show
  before_action :set_current_user_post, only: :destroy

  # 投稿詳細
  def show
    # @post 下記
    # 投稿に対するレビュー集
    @reviews = @post.reviews.includes(:user, :goods, :bads)
    # レビューを新規作成
    @review = if user_signed_in?
                current_user.reviews.build
              else
                Review.new
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
      # Rails7 Turbo
      render :new, status: :unprocessable_content # 422エラー
    end
  end

  def destroy
    @post.destroy
    flash[:alert] = '投稿を削除しました'
    redirect_to root_url, status: :see_other
  end

  private

  # create
  def post_params
    params.expect(
      post: [
        :content,
        :address,
        :spot_quality, # radio
        { spot_type: [] } # checkbox
      ]
    )
  end

  # 投稿のない詳細画面は表示できない show
  def set_post
    @post = Post.includes(:user).find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end

  # 他人の投稿は削除できない destroy
  def set_current_user_post
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
