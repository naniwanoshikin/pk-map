module NotificationsHelper
  # 未確認の通知を検索
  def unchecked_notifications # (layouts/circle)
    current_user.passive_notifications.where(checked: false).where.not(visitor_id: current_user.id)
  end
end
