require 'rails_helper'

describe User, type: :model do # 6
  before { @user = User.new(
    name:     "Example User",
    email:    "user@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  )}
  subject { @user }

  # 属性の存在
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  # @userの認証
  it { should respond_to(:valid_password?) } # authenticateの代替
  # @userの有効性
  it { should be_valid }

  # 存在性
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  # 長さ
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when email is too long" do
    before { @user.name = 'a' * 244 + "@example.com" }
    it { should_not be_valid }
  end
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  # フォーマット
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  # 重複を拒否
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      # 大文字小文字を区別しない
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # before_save アドレスを小文字変換
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as all lower-case" do
      @user.update_attribute(:email, mixed_case_email) # 変えた
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # パスワードが空
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  # パスワードが違う
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  # パスワードの認証
  describe "return value of authenticate method" do
    # 事前にユーザーをDBに保存
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    # @userとfound_userのパスワードを比較
    # 一致する場合
    describe "valid password" do
      specify { expect(found_user.valid_password?(@user.password)).to be true } # 変えた
    end
    # 一致しない場合
    describe "invalid password" do
      let(:user_for_invalid_password) { found_user.valid_password?("invalid") } # authenticateの代替
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be false } # 変更
    end
  end
end
