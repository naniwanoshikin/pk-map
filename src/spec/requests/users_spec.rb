require 'rails_helper'

describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }

  it 'POST /users (ログイン)' do
    post user_session_path, params: { user: {
      email: user.email,
      password: user.password,
    } }
    expect(response).to have_http_status(302) # 302リダイレクトの検証
  end

  describe "DELETE #destroy (ユーザー削除)" do
    let!(:admin_user) { FactoryBot.create(:user, admin: true) } # 管理者
    let!(:other_user) { FactoryBot.create(:user) }

    it "削除するとユーザー一覧画面にリダイレクトされる" do
      sign_in admin_user # 管理者としてログイン Devise
      expect {
        delete user_path(other_user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to users_path
    end
  end

  # 編集
  describe "PATCH /users/:id" do
    let(:user) { FactoryBot.create(:user) }

    it 'ユーザー情報編集' do
      sign_in user # 編集する本人
      patch user_registration_path, params: { user: {
        current_password: user.password,
        name: "Foo Bar",
        email: "foo@bar.com"
      } }
      expect(response).to have_http_status(302)
    end
  end

end
