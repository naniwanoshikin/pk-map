# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 未確認通知の一覧 User(M)
    unconfirms = current_user.passive_notifications

    # 全件既読にする (意図的にrubocop許可)
    # rubocop:disable-next Rails/SkipsModelValidations
    unconfirms.where(checked: false).update_all(checked: true)

    # 未読チェック用キャッシュ = 「未読は空[]だよ」というメモ箱
    # helper_右辺にいかない = SQLは走らない
    @unchecked_notifications = []

    # 通知一覧を一括取得 SQL減らす対策
    @notifications = unconfirms.includes(:visitor, :post, review: :post)
                               .page(params[:page]).per(8)
                               .without_count

    respond_to do |format|
      format.html # ▶︎初回(index.html)
      format.turbo_stream # 「もっと見る」が押された時
    end
  end
end
