class ApplicationController < ActionController::Base

  def hello
    render html: "CDでhello, world 1/31"
  end

  private # 5 名前付きルート perfix
  # ログイン後のpath
  def after_sign_in_path_for(resource) # 引数はid?
    user_path(resource)
  end
  # ログアウト後のpath
  def after_sign_out_path_for(resource)
    root_path
  end

end
