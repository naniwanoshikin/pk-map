require 'rails_helper'

describe "Authentication", type: :request do

  subject { page }
  describe "with valid information" do
    let(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    it { should have_link('Profile',  href: user_path(user)) }
    it { should have_link('Settings', href: edit_user_registration_path) }
    it { should have_link('Log out', href: logout_path) }
    it { should_not have_link('Log in', href: login_path) }

  end

end