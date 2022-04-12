class BadsController < ApplicationController
  before_action :authenticate_user!

  # 低評価する
  def create
    @review = Review.find(params[:review])

    current_user.bad(@review)


    # 高評価を解除
    if Good.find_by(user_id: current_user.id, review_id: @review.id)
      current_user.ungood(@review)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  # 低評価を解除
  def destroy
    @review = Bad.find(params[:id]).review
    current_user.unbad(@review)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end
end
