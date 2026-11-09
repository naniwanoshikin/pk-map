class BadsController < ApplicationController
  before_action :authenticate_user!

  # 低評価する
  def create
    @review = Review.find(params[:review])

    current_user.bad(@review)

    # @reviewを既に高評価していれば自動解除
    current_user.goods.find_by(review_id: @review.id)&.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.turbo_stream
    end
  end

  # 低評価を解除
  def destroy

    bad = Bad.find_by(id: params[:id])
    @review = bad&.review

    if @review
      current_user.unbad(@review)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.turbo_stream
    end
  end
end
