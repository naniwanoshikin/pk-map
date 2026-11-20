# frozen_string_literal: true

module TestHelper
  # ログインしてたらtrue 8
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログイン 9
  def log_in_as(user, remember_me: '1')
    post login_path, params: { session: {
      email: user.email,
      password: user.password,
      remember_me: remember_me
    } }
  end
end

module SystemHelper
  def login_as(user)
    visit login_path
    fill_in 'user[email]',    with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
end
