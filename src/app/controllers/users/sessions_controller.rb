# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # ゲストログイン
  def guest_in1
    user = User.guest1
    sign_in user
    redirect_to root_path, notice: 'ユーザー2'
  end
  def guest_in2 # routes
    user = User.guest2 # User(M)
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
  def guest_in3
    user = User.guest3
    sign_in user
    redirect_to root_path, notice: 'ユーザー3'
  end

  protected
  # フレンドリーフォワーディング
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super # Application(C)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
