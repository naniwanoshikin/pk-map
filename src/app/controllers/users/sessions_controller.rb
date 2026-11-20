# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
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

    # ゲストログイン routes
    def guest_in1
      guest_sign_in(User.guest1, '管理者ユーザー') # User(M)
    end

    def guest_in2
      guest_sign_in(User.guest2, 'ゲストユーザーとしてログインしました。')
    end

    def guest_in3
      guest_sign_in(User.guest3, 'ユーザー3')
    end

    protected

    # フレンドリーフォワーディング
    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || super # Application(C)
    end

    private

    def guest_sign_in(user, message)
      sign_in user
      # Rails 7 (Turbo) では POST 後のリダイレクトに (303) が必須
      redirect_to user, status: :see_other, notice: message
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
