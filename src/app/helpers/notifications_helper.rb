module NotificationsHelper
  # 未確認の通知を検索
  def unchecked_notifications # (layouts/circle)
    current_user.passive_notifications.where(checked: false)
  end

  # (notifications/_notification)
  # アクションに応じたFontAwesomeのクラス
  def notification_icon_class(action)
    case action
    when 'follow' then 'fas fa-user'
    when 'good' then 'fas fa-heart'
    when 'review' then 'far fa-comment'
    end
  end

  # アクションに応じた文言を返す
  def notification_action_text(action)
    case action
    when 'follow' then 'にフォローされました'
    when 'good' then 'がレビューを評価しました'
    when 'review' then 'がレビューしました'
    end
  end

    # 3. 遷移先の投稿（Post）を安全に取得
  def notification_target_post(notification)
    notification.action == 'good' ? notification.review.post : notification.post
  end

end
