require 'rails_helper'

describe 'ユーザ一覧', type: :system do # 10
  let(:user) { FactoryBot.create(:user) }

  before do
    visit new_user_session_path
    login_as(user)
    click_link 'Settings'
  end

  
end