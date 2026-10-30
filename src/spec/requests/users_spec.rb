require 'rails_helper'

describe 'Users', type: :request do
  # FactoryBotの定義に合わせて指定
  let(:password) { "foobar" }
  let(:user) { FactoryBot.create(:user) }

  it 'POST /users (ログイン)' do
    # (routes.rb) 独自の名前付きルートに生のパスワードを送信
    post login_path, params: { user: {
      email: user.email,
      password: password,
    } }
    expect(response).to have_http_status(302) # 成功してリダイレクト
  end

  describe "DELETE #destroy (ユーザー削除)" do
    let!(:admin_user) { FactoryBot.create(:user, :admin) } # 管理者
    let!(:other_user) { FactoryBot.create(:user) }

    it "削除するとユーザー一覧画面にリダイレクトされる" do
      # Wardenヘルパー経由でカスタムコントローラーにログインを認識
      login_as(admin_user, scope: :user)

      expect {
        delete user_path(other_user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to users_path
    end
  end

  describe "PATCH /users/:id" do
    let(:user) { FactoryBot.create(:user) }

    it 'ユーザー情報編集' do
      # 同様にログイン状態をモック
      login_as(user, scope: :user)

      # カスタムコントローラー（users/registrations）への更新リクエスト
      patch user_registration_path, params: { user: {
        current_password: user.password,
        name: "Foo Bar",
        email: "foo@bar.com"
      } }
      expect(response).to have_http_status(302)
    end
  end

end
