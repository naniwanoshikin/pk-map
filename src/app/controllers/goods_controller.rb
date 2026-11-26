# frozen_string_literal: true

class GoodsController < ApplicationController
  before_action :authenticate_user!

  # 高評価する
  def create
    @review = Review.find(params.expect(:review))

    current_user.good(@review)
    # @reviewを既に低評価していれば自動解除 SQL対策
    current_user.bads.delete_by(review_id: @review.id)
    # @review した人に通知
    current_user.notify_to_good!(@review)

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
end
