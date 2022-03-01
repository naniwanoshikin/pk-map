class NotificationsController < ApplicationController
  def index
    # 未確認の通知レコード集
    unconfirms = current_user.passive_notifications

    # 確認済 にする
    unconfirms.where(checked: false).each do |unconfirm|
      unconfirm.update(checked: true)
    end

    # 自分以外の通知一覧
    @notifications = unconfirms.where.not(visitor_id: current_user.id)
  end
end
