class ApplicationController < ActionController::Base
  def hello
    render html: "hello, world 1/31マジか CD使ってできたかも?"
  end


  private # 5 rails routes perfix
  def after_sign_in_path_for(resource)
     root_path # ログイン後のpath
  end

  def after_sign_out_path_for(resource)
    new_user_session_path # ログアウト後のpath
  end

end
