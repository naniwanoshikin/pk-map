class ApplicationController < ActionController::Base
  # 10
  before_action :config_permitted_parameters, if: :devise_controller?

  private
  # 5
  # 登録後
  def after_sign_up_path_for(resource)
    user_path(resource)
  end
  # ログイン後
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  # 10
  def config_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
