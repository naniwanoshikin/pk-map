# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # ゲストユーザーは更新・削除できない
  before_action :guest_user_not, only: [:update, :destroy]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
  # ユーザー情報編集
  # '現在のパスワード'を入力不要にする
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  # 編集後のパス
  def after_update_path_for(resource)
    user_path(resource)
  end

  def guest_user_not # email: User(M)
    if resource.email == 'example-1@railstutorial.org' || resource.email == 'example-4@railstutorial.org' || resource.email == 'example@railstutorial.org'
      redirect_to edit_user_registration_path,
      alert: 'ゲストユーザーは更新・削除できません。'
    end
  end

  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up,
  #     keys: [:name]
  #   )
  # end

  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
