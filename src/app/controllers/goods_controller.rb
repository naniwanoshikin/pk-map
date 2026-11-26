# frozen_string_literal: true

class GoodsController < ApplicationController
  before_action :authenticate_user!

  # 高評価する
  def create
    @review = Review.find(params.expect(:review))

    perform_good(@review)

    respond_to do |format|
      format.html { redirect_back_or_to(root_url) }
      format.turbo_stream
    end
  end

  # 高評価を解除
  def destroy
    # 自分の高評価のみ対象 & 連打対策
    good = current_user.goods.find_by(id: params[:id])
    return head :no_content unless good

    @review = good.review
    good.destroy

    respond_to do |format|
      format.html { redirect_back_or_to(root_url) }
      format.turbo_stream
    end
  end

  private

  def perform_good(review)
    # @reviewを高評価
    current_user.good(review)
    # @review した人に通知
    current_user.notify_to_good!(review)
    # @reviewを既に低評価していれば自動解除
    current_user.bads.find_by(review_id: review.id)&.destroy
  end
end
