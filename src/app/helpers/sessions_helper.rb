module SessionsHelper

  # 渡されたuserがカレントユーザーであればtrueを返す
  def current_user?(user) # 10
    user && user == current_user
  end

end