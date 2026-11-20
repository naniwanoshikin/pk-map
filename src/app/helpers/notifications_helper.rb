# frozen_string_literal: true

module NotificationsHelper
  NOTIFICATION_ICONS = {
    'follow' => 'fas fa-user',
    'good' => 'fas fa-heart',
    'review' => 'far fa-comment'
  }.freeze

  NOTIFICATION_TEXTS = {
    'follow' => 'がフォローしました',
    'review' => 'がレビューしました',
    'good' => 'がレビューにいいねしました'
  }.freeze

  # 未確認の通知を検索 (layouts/circle)
  def unchecked_notifications
    current_user.passive_notifications.where(checked: false)
  end

  # (notifications/_notification)
  # アクションに応じたFontAwesomeのクラス
  def notification_icon_class(action)
    NOTIFICATION_ICONS[action]
  end

  # アクションに応じた文言を返す
  def notification_action_text(action)
    NOTIFICATION_TEXTS[action]
  end

  # 3. 遷移先の投稿（Post）を安全に取得
  def notification_target_post(notification)
    notification.action == 'good' ? notification.review.post : notification.post
  end
end
