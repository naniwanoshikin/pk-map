require 'rails_helper'

describe 'ログイン', type: :system do # 8
  subject { page }

  before { visit new_user_session_path }
  let(:user) { FactoryBot.create(:user) }

  scenario 'ログイン失敗: 無効なパスワード' do
    fill_in 'Eメール',    with: user.email
    fill_in 'パスワード', with: ' '
    click_on 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_error_message('Eメールまたはパスワードが違います。') # (support/utilities.rb)
    expect(has_css?('.alert-alert')).to be true
    visit current_path
    expect(has_css?('h2.alert-alert')).to be false
  end

  scenario 'ログイン成功' do
    sign_in(user) # (support/utilities.rb)
    expect(current_path).to eq user_path(user)
    expect(page).to have_link('マイページ', href: user_path(user))
    expect(page).to have_link('ログアウト', href: logout_path)
    expect(page).to have_no_link 'Log in'
    expect(page).to have_title(full_title(user.name))

    click_on 'ログアウト'
    expect(current_path).to eq root_path
    # expect(is_logged_in?).to be_falsy # undefinedなる...
    expect(page).to have_link('Log in')
    expect(page).to have_no_link('ログアウト')
    # 2番目のウィンドウでログアウト 9
    delete logout_path
    expect(response).to redirect_to root_path
    expect(is_logged_in?).to be false # (test_helper)
  end

  # 9
  describe 'remember me チェックボックス' do
    it 'login with チェックあり' do
      log_in_as(user) # (test_helper)
      # expect(cookies[:remember_token]).not_to eq nil # ?
    end
    it 'login without チェックなし' do
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token]).to eq nil
    end
  end

end
