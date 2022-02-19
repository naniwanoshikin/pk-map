require 'rails_helper'

describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "friendly forwarding" do
    let(:user) { FactoryBot.create(:user) }
    it 'succeeds' do
      get user_registration_path(user)
      log_in_as(user)
      # expect(response).to redirect_to user_registration_url(user)
    end
  end
end