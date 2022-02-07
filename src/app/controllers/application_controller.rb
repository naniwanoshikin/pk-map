class ApplicationController < ActionController::Base
  def hello
    render html: "hello, world 1/31マジか CD使ってできたかも?"
  end


  private # 5
  # ログイン後のpath = 名前付きルート perfix
  def after_sign_in_path_for(resource) # 引数はid?
    user_path(resource)
  end
  # ログアウト後のpath
  def after_sign_out_path_for(resource)
    root_path
  end

end
