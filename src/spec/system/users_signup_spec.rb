require 'rails_helper'

describe 'ユーザー登録', type: :system do
  subject { page }
  before { visit new_user_registration_path }

  describe '新規登録' do # 7
    let(:submit) { 'アカウント登録' }

    describe '無効な登録' do
      before do
        fill_in 'user[name]',         with: ' '
        fill_in 'user[email]',        with: 'user@invalid'
        fill_in 'user[password]',     with: 'foo'
        fill_in 'user[password_confirmation]', with: 'bar'
        click_on submit
      end
      # 今いるページ
      it { should have_current_path users_path }
      it { should have_title('新規登録') }
      it { should have_content('エラー') }
      it { should have_selector('#error_explanation') }
      # flash
      it { should have_selector('h2.alert.alert-danger') }
    end

    let(:user) { FactoryBot.attributes_for(:user) } # ハッシュ
    it '有効な登録' do
      expect do
        post users_path, params: { user: user }
      end.to change(User, :count).by(1)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to user_url(User.last)
      # expect(is_logged_in?).to be_truthy # なぜtrueならない?
    end

    describe '有効なユーザー登録後のflash' do
      before do
        fill_in 'user[name]', with: 'Example User'
        fill_in 'user[email]', with: 'user@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on submit
      end
      it do
        # expect(is_logged_in?).to be_truthy # なぜ使えない?
        expect(current_path).to eq user_path(User.last)
        expect(has_css?('.alert-notice')).to be true
        visit current_path
        expect(has_css?('.alert-notice')).to be false
      end
    end
  end

  # describe 'プロフィール 画面' do # 7
  #   let(:user) { FactoryBot.create(:user) }
  #   before { visit user_path(user) }
  #   it { should have_content(user.name) }
  #   it { should have_title(full_title(user.name)) }
  # it { should have_link('Log out') } # 8 ログアウト表示
  # it { should have_title(full_title(user.name)) }
  # end
end
