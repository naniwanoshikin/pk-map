class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @post = current_user.posts.build
      # pagination ajax
      @feed_items = current_user.feed.page(params[:page]).per(5)
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
end
