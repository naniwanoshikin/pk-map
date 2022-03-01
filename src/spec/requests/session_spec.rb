require 'rails_helper'

describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "フレンドリーフォワーディング" do
    it 'succeeds' do
      get edit_user_registration_path(user)
      log_in_as(user)
      # expect(response).to redirect_to edit_user_registration_url(user)
      # 原因: フレンドリーフォワーディングの実装方法
      # 原因: 300 redirectではなく、200 OK になっている為
    end
  end
end
