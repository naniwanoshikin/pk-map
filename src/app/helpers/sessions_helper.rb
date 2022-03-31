module SessionsHelper

  # userが現在のユーザーであればtrue
  def current_user?(user) # 10
    user && user == current_user
  end

end
