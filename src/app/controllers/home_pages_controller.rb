class HomePagesController < ApplicationController
  def home
    return unless user_signed_in?

    @post = current_user.posts.build
    @url = root_path

    # Ransack 投稿検索
    @q = current_user.feed.ransack(posts_search_params)
    # (shared/feed)
    # 検索結果フィード（地図のピン & タイムライン共通）
    @feed_items = @q.result.includes(:user).page(params[:page]).per(6)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def help
  end

  def about
    return unless user_signed_in?

    @stats = {
      users_count: User.count,
      posts_count: Post.count,
      reviews_count: Review.count,
      review_notifications_count: Notification.where(action: 'review').count
    }
    if Rails.env.development?
      @stats.merge!(
        goods_count: Good.count,
        good_notifications_count: Notification.where(action: 'good').count,
        relationships_count: Relationship.count,
        follow_notifications_count: Notification.where(action: 'follow').count
      )
    end

  end

  def contact
  end

  private
    def posts_search_params
      # params[:q] が存在しない場合や空の場合もエラーにならないよう fetch
      params.fetch(:q, {}).permit(:content_cont)
    end
end
