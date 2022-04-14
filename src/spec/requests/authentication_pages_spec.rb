require 'rails_helper'

describe "Authentication", type: :request do

  subject { page }
  describe "with valid information" do
    let(:user) { FactoryBot.create(:user) }
    before { sign_in user } # utilities
    # あり
    it { should have_link('ログアウト', href: logout_path) }
    # ない
    it { should_not have_link('ログイン', href: login_path) }

  end

end
