require 'rails_helper'

describe "Sessions", type: :request do
  subject { page }

  describe "ログイン画面" do # 8
    before { visit new_user_session_path }
    it { should have_content('ログイン') }
    it { should have_title(full_title('ログイン')) }
  end

  describe "ログイン" do # 8
    before { visit new_user_session_path }

    describe "ログイン失敗" do
      before { click_button "ログイン" }
      # 何も入力しないでログインボタン押す
      it { should have_title(full_title('ログイン')) }
      it { should have_error_message('Eメールまたはパスワードが違います。') } # (support/utilities.rb)
      # flashメッセージが消える
      describe "別ページへ遷移後" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-alert') }
      end
    end

    let(:user) { FactoryBot.create(:user) }
    describe "ログイン成功" do
      before { valid_signin(user) } # (support/utilities.rb)

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Log out', href: destroy_user_session_path) }
      it { should have_no_link('Log in', href: new_user_session_path) }
      # ログアウトする
      describe "followed by signout" do
        before { click_link "Log out" }
        it { should have_link('Log in') }
        it { should have_no_link('Log out') }
      end
      # 9.1.4
      it '2番目のウィンドウでユーザーをログアウト' do
        delete logout_path
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(is_logged_in?).to be_falsy # (support)
        end
      end
    end
    # 9.3.1
    describe 'remember me チェックボックス' do
      it "login with remembering" do
        log_in_as(user) # (support)
        # expect(cookies[:remember_token]).not_to eq nil # ?
      end
      it "login without remembering" do
        log_in_as(user, remember_me: '0')
        expect(cookies[:remember_token]).to eq nil
      end
    end
  end
end
