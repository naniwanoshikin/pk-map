require 'rails_helper'

describe 'ユーザー編集', type: :system do # 10
  let(:user) { FactoryBot.create(:user) }
  before do
    visit new_user_session_path
    login_as(user)
    click_link 'ホーム'
    click_link 'プロフィール編集'
  end

  scenario '編集失敗: 無効な値' do
    fill_in 'user[name]',         with: ' '
    fill_in 'user[email]',        with: 'user@invalid'
    fill_in 'user[password]',     with: 'foo'
    fill_in 'user[password_confirmation]', with: 'bar'
    click_on '更新'
    expect(current_path).to eq users_path
    expect(has_css?('.alert-danger')).to be true
  end

  scenario '編集成功' do
    fill_in 'user[name]',         with: 'Foo Bar'
    fill_in 'user[email]',        with: 'foo@bar.com'
    fill_in 'user[password]',     with: ''
    fill_in 'user[password_confirmation]', with: ''
    click_on '更新'
    expect(current_path).to eq user_path(user)
    expect(has_css?('.alert-notice')).to be_truthy
  end

end
