require 'rails_helper'

RSpec.describe User, type: :model do
  # 仮で書いてみた
  describe 'ユーザー登録' do
    it "name、email、passwordとpassword_confirmationが存在すれば登録できること" do
      # user = build(:user)
      # expect(user).to be_valid  # user.valid? が true になればパス
    end
  end
end
