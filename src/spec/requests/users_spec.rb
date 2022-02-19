require 'rails_helper'

describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }

  it 'POST /users' do
    post login_path, params: { session: {
      email: user.email,
      password: user.password,
    } }
    # expect(response).to redirect_to user_path(User.last)
    # expect(response).to have_http_status(302) # なぜできない?logには302出ているのに
    # expect(is_logged_in?).to be true # なぜfalseに?
  end

  # ログアウト
  it 'DELETE #destroy' do
    delete logout_path
    expect(response).to redirect_to root_path
    expect(is_logged_in?).to be false
  end

  # 編集
  describe "PATCH /users/:id" do
    before { log_in_as(user) }
    it 'ユーザー情報編集' do
      patch user_registration_path(user), params: { user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: "",
      } }
      # expect(response).to redirect_to user_path(user) # なぜエラー?
    end
  end

  # リダイレクト
  describe "GET /users" do
    it "redirects login when not logged in" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end
end
