module ApplicationHelper

  # ページごとの完全なタイトルを返す (4.1)
  def full_title(page_title = '')
    base_title = "PK マップ"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # (posts/new)_バリデーションエラー時 (@post, :address)とか
  # 1. ラベルを赤太字にする
  def form_label_class(object, attribute)
    base = "form-label"
    object.errors[attribute].any? ? "#{base} fw-bolder text-danger" : "#{base} fw-bold"
  end
  # 2. Bootstrap 5 赤枠（is-invalid）を付ける
  def form_control_class(object, attribute)
    base = "form-control"
    object.errors[attribute].any? ? "#{base} is-invalid" : base
  end
end
