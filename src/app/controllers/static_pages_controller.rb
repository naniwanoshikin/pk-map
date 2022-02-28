class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.page(params[:page]).per(5)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
