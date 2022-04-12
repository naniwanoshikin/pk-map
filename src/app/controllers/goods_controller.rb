class GoodsController < ApplicationController
  before_action :authenticate_user!

  # 高評価する
  def create
    @review = Review.find(params[:review])
    # @reviewを高評価する
    current_user.good(@review)
    # @review.userに通知する
    current_user.notify_to_good!(@review)
    # 既に低評価していれば低評価を解除
    if Bad.find_by(user_id: current_user.id, review_id: @review.id)
      current_user.unbad(@review)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  # 高評価を解除
  def destroy
    @review = Good.find(params[:id]).review
    current_user.ungood(@review)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
