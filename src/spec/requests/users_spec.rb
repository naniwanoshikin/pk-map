require 'rails_helper'

describe "Users pages", type: :request do
  subject { page }

  describe "新規登録 画面" do # 5
    before { visit new_user_registration_path }

    it { should have_content('アカウント登録') }
    it { should have_title(full_title('新規登録')) }
  end

  describe "プロフィール 画面" do # 7
    let(:user) { FactoryBot.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(full_title(user.name)) }
  end

  describe "新規登録" do # 7
    before { visit new_user_registration_path }
    let(:submit) { "アカウント登録" }

    describe "無効な登録" do
      it "未入力" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "登録後" do
        before { click_button submit }
        it { should have_title('新規登録') }
        it { should have_content('エラー') }
        it { should have_selector('#error_explanation') }
        # 今いるページ
        # it { should have_current_path '/users' }
      end
    end

    describe "有効な登録" do
      before do
        fill_in "user[name]",         with: "Example User"
        fill_in "user[email]",        with: "user@example.com"
        fill_in "user[password]",     with: "foobar"
        fill_in "user[password_confirmation]", with: "foobar"
      end
      it "登録" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "登録後" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }
        it { should have_link('Log out') } # 8 ログアウト表示
        it { should have_title(full_title(user.name)) }
        # flash
        it { should have_selector('div.alert.alert-notice', text: 'アカウント登録が完了しました。') }
      end
    end
  end
end
