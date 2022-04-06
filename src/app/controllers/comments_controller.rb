class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :good_users]
  before_action :correct_user,     only: :destroy
  # コメントのない画面は表示できない
  before_action :correct_comment,  only: [:show, :good_users]

  # コメントする
  def create
    @comment = current_user.comments.build(comment_params)
    @post = @comment.post
    @comments = @post.comments
    if @comment.save
      # 通知
      current_user.notify_to_comment!(@post, @comment.id)

      # (comments/form)
      respond_to do |format|
        format.html { redirect_to @post, notice: 'レビューを追加しました' }
        # format.js { flash.now[:notice] = "レビューを追加しました" }
      end
    else
      gon.post = @post # map js
      flash.now[:alert] = "星レビューを入力してください"
      respond_to do |format|
        # 失敗時のajaxできず...
        format.html { render 'posts/show' }
        # format.js { flash.now[:alert] = "星レビューを入力してください" }
      end
    end
  end

  # コメント削除
  def destroy
    # @comment
    @post = @comment.post
    @comments = Comment.where(post_id: @post.id)
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post, alert: 'レビューを削除しました' }
      format.js { flash.now[:alert] = "レビューを削除しました" }
    end
  end

  # コメント詳細
  def show
  end

  # 高評価したユーザー一覧
  def good_users
    # @comment
    @comment_good_users = @comment.good_users.page(params[:page]).per(10)
  end

  private
    def comment_params
      # (posts/show)
      params.require(:comment).permit(
        :post_id,
        :score,
        :content,
      )
    end

    def correct_user # destroy
      @comment = current_user.comments.find_by(id: params[:comment_id]) # (comments/comment)
      redirect_to root_url if @comment.nil?
    end

    def correct_comment # show, good_users
      @comment = Comment.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
