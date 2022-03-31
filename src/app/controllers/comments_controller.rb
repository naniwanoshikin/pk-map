class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user,     only: :destroy
  # コメントのない詳細画面は表示できない
  before_action :correct_comment,  only: :show

  # コメントする
  def create
    @comment = current_user.comments.build(comment_params)
    @post = @comment.post
    @comments = @post.comments
    if @comment.save
      # 通知
      current_user.notify_to_comment!(@post, @comment.id)

      respond_to do |format|
        format.html { redirect_to @post, notice: 'コメントしました' }
        format.js
      end
    else
      # map JS用
      gon.post = @post
      render 'posts/show'
    end
  end

  # コメント削除
  def destroy
    # @comment
    @post = @comment.post
    @comments = Comment.where(post_id: @post.id)
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post, alert: 'Comment deleted' }
      format.js { flash[:danger] = "Comment deleted" }
    end
  end

  # コメント詳細
  def show
  end

  # いいねしたユーザー一覧
  def like_users
    @comment = Comment.find(params[:id])
    @comment_like_users = @comment.like_users.page(params[:page]).per(10)
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

    def correct_comment # show
      @comment = Comment.find_by(id: params[:id])
      # redirect_to root_url if @comment.nil?
    end
end
