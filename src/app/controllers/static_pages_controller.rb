class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @post = current_user.posts.build
      # 住所一覧 (_map, shared/feed)
      gon.posts = Post.all

      # 投稿検索がヒットした時
      if params[:q] && params[:q].reject { |value| value.blank? }.present?
        @q = current_user.feed.ransack(posts_search_params)
        @feed_items = @q.result.page(params[:page]).per(6)
      else
        # 検索していない時
        @q = Post.none.ransack

        # (shared/_feed)
        @feed_items = current_user.feed.page(params[:page]).per(6)

        # (shared/_feed) JS map
        gon.feed = @feed_items

      end
      @url = root_path

      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  private
    def posts_search_params
      params.require(:q).permit(:content_cont)
    end
end
