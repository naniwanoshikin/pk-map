# full_titleヘルパー用 5
include ApplicationHelper # (helpers/application_helper_spec.rb)

# ログイン用 8_2版
def valid_signin(user)
  fill_in "Eメール",    with: user.email
  fill_in "パスワード", with: user.password
  click_button "ログイン"
end
# エラーメッセージ用 2版
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-alert', text: message)
  end
end

# 8 ログインしてたらtrue
def is_logged_in?
  !session[:user_id].nil?
end

# 9.3.1 テストユーザーとしてログインする (統合テスト)
def log_in_as(user, remember_me: '1')
  post login_path, params: { session: {
    email: user.email,
    password: user.password,
    remember_me: remember_me,
  } }
end