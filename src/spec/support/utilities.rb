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
