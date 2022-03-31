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
end
