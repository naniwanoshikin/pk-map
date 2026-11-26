# frozen_string_literal: true

class BadsController < ApplicationController
  before_action :authenticate_user!

  # 低評価する
  def create
    @review = Review.find(params.expect(:review))

    current_user.bad(@review)

    # @reviewを既に高評価していれば自動解除
    current_user.goods.find_by(review_id: @review.id)&.destroy

    respond_to do |format|
      format.html { redirect_back_or_to(root_url) }
      format.turbo_stream
    end
  end

  # 低評価を解除
  def destroy
    # 自分の高評価のみ対象 & 連打対策
    bad = current_user.bads.find_by(id: params[:id])
    return head :no_content unless bad

    @review = bad.review
    bad.destroy

    respond_to do |format|
      format.html { redirect_back_or_to(root_url) }
      format.turbo_stream
    end
  end
end
