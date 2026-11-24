# frozen_string_literal: true

class HomePagesController < ApplicationController
  def home
    return unless user_signed_in?

    @post = current_user.posts.build
    @url = root_path
    # (shared/feed) 検索結果フィード (地図のピン & タイムライン共通)
    @feed_items = fetch_feed_items

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def help; end

  def about
    return unless user_signed_in?

    # SQL対策 通知の件数を action ごとに1回でまとめて取得
    notification_counts = Notification.unscope(:order).group(:action).count

    # SQL対策 usersテーブルへの1回のアクセスでまとめて取得
    users_count, posts_count, reviews_count = User.pick(
      Arel.sql('COUNT(*), COALESCE(SUM(posts_count), 0), COALESCE(SUM(reviews_count), 0)')
    )

    @stats = {
      users_count: users_count, # SQL対策
      posts_count: posts_count, # SQL対策
      reviews_count: reviews_count, # SQL対策
      review_notifications_count: notification_counts['review'] || 0
    }

    return unless Rails.env.development?

    @stats.merge!(
      goods_count: Good.count,
      good_notifications_count: notification_counts['good'] || 0,
      relationships_count: Relationship.count,
      follow_notifications_count: notification_counts['follow'] || 0
    )
  end

  def contact; end

  private

  def fetch_feed_items
    # Ransack 投稿検索
    @q = current_user.feed.ransack(posts_search_params)
    @q.result.includes(:user).page(params[:page]).per(6)
  end

  def posts_search_params
    # params[:q] が存在しない場合や空の場合もエラーにならないよう fetch
    params.fetch(:q, {}).permit(:content_cont)
  end
end
