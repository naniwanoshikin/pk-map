class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user,   only: :destroy

  # コメントする
  def create
    @comment = current_user.comments.build(comment_params)
    @post = @comment.post
    if @comment.save
      # 通知
      current_user.notify_to_comment!(@post, @comment.id)

      redirect_to @post, notice: 'コメントしました'
    else
      @comments = @post.comments
      render 'posts/show'
    end
  end

  # コメント削除
  def destroy
    # @comment
    @post = @comment.post
    @comments = Comment.where(post_id: @comment.post_id)
    @comment.destroy
    redirect_to @post, alert: 'コメントを削除しました'
  end

  private
    def comment_params
      # (posts/show)
      params.require(:comment).permit(
        # :user_id,
        :post_id,
        :content
      )
    end
    def correct_user
      @comment = current_user.comments.find_by(post_id: params[:post_id]) # (comments/comment)_path
      redirect_to root_url if @comment.nil?
    end
end