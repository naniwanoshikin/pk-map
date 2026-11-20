# frozen_string_literal: true

module SessionsHelper
  # userが現在のユーザーであればtrue
  def current_user?(user)
    user && user == current_user
  end
end
