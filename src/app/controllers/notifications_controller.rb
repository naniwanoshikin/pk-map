class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 未確認の通知一覧
    unconfirms = current_user.passive_notifications

    # 確認済 にする
    unconfirms.where(checked: false).each do |unconfirm|
      unconfirm.update(checked: true)
    end

    # 画面に表示される通知一覧
    @notifications = unconfirms.page(params[:page]).per(5)
  end
end
