require 'rails_helper'

describe 'StaticPages', type: :system do
  before { visit root_path }

  it 'リンク先のタイトルをテスト' do # 3
    expect(page).to have_title(full_title(''))
    click_link 'About'
    expect(page).to have_title(full_title('About'))
    click_link 'Contact'
    expect(page).to have_title(full_title('Contact'))
    click_link 'PK map'
    click_link '登録'
    expect(page).to have_content('アカウント登録')
    expect(page).to have_title(full_title('新規登録'))
    click_link 'PK map'
    expect(page).to have_title(full_title(''))
    click_link 'Log in' # 8
    expect(page).to have_content('ログイン')
    expect(page).to have_title(full_title('ログイン'))
  end

  it 'リンクとパスのテスト' do # 5
    expect(page).to have_link 'PK map',  href: root_path
    expect(page).to have_link 'About',   href: about_path
    expect(page).to have_link 'Contact', href: contact_path
    # expect(page).to have_link 'Sign up now!', href: new_user_registration_path # hrefがだめ?
  end
end
