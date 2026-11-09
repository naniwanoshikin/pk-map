class GoodsController < ApplicationController
  before_action :authenticate_user!

  # 高評価する
  def create
    @review = Review.find(params[:review])
    # @reviewを高評価 / @review の作者に通知
    current_user.good(@review)
    current_user.notify_to_good!(@review)
    # @reviewを既に低評価していれば自動解除
    current_user.bads.find_by(review_id: @review.id)&.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.turbo_stream
    end
  end

  # 高評価を解除
  def destroy
    # 1. 連打対策
    good = Good.find_by(id: params[:id])
    @review = good&.review
    # 2. 連打対策
    if @review
      current_user.ungood(@review)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.turbo_stream
    end
  end
end
