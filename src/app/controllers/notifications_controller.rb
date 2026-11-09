class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 未確認通知の一覧 User(M)
    unconfirms = current_user.passive_notifications

    # 一括で確認済みにする
    unconfirms.where(checked: false).update_all(checked: true)

    # 表示される通知一覧を一括取得 includes(N+1問題対策)
    @notifications = unconfirms.includes(:visitor, :post, review: :post).page(params[:page]).per(5)

    respond_to do |format|
      format.html # 初回表示 ▶︎index.html
      format.turbo_stream # 「もっと見る」が押された時
    end
  end
end
