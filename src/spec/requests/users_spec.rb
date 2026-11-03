require 'rails_helper'

describe 'Users', type: :request do
  let(:password) { "foobar" }

  before do
    # 最大の対策: テスト環境でのジオコーディング（外部API通信）を完全にスタブ化して検証落ちを防ぐ
    allow_any_instance_of(User).to receive(:geocode).and_return([35.681236, 139.767125])
  end

  # FactoryBotのデフォルト定義を上書きして明示的に作成
  let!(:user) { FactoryBot.create(:user, email: "test@example.com", password: password, password_confirmation: password, address: "梅田") }

  it 'POST /users (ログイン)' do
    post login_path, params: { user: {
      email: user.email,
      password: password,
    } }
    expect(response).to have_http_status(302) # 成功してリダイレクトされる
  end

  describe "DELETE #destroy (ユーザー削除)" do
    # admin 属性を true に設定して管理者を作成
    let!(:admin_user) { FactoryBot.create(:user, admin: true, password: "password", password_confirmation: "password", address: "梅田") } 
    let!(:other_user) { FactoryBot.create(:user, address: "梅田") }

    it "削除するとユーザー一覧画面にリダイレクトされる" do
      sign_in admin_user

      expect {
        delete user_path(other_user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to users_path
    end
  end

  describe "PATCH /users/:id" do
    let(:edit_password) { "foobar" }
    let!(:edit_user) { FactoryBot.create(:user, password: edit_password, password_confirmation: edit_password, address: "梅田") }

    it 'ユーザー情報編集' do
      sign_in edit_user

      # 💡 対策: Userモデルの定義に合わせて、現在のパスワード（生文字列）を確実に送信
      patch user_registration_path, params: { user: {
        current_password: edit_password, 
        name: "New Name",
        email: "new_email@example.com"
      } }
      expect(response).to have_http_status(302)
    end
  end
end
