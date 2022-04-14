# ログイン用 8

def sign_in(user)
  visit new_user_session_path
  fill_in "Eメール",    with: user.email
  fill_in "パスワード", with: user.password
  find('#hoge').click # (devise/sessions/new)_ログインの重複
  # Capybaraを使用していない場合にもサインインする。
  # cookies[:remember_token] = user.remember_token
end


# エラーメッセージ用 2版
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-alert', text: message)
  end
end
