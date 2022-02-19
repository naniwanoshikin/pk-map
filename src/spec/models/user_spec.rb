require 'rails_helper'

describe User, type: :model do # 6

  let(:user) { FactoryBot.build(:user) }

  subject { user }

  # 属性の存在
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  # userの認証
  it { should respond_to(:valid_password?) } # authenticateの代替

  # userの有効性
  it { should be_valid }

  # 存在性
  it '名前なし' do
    user.name = ' '
    expect(user).to be_invalid
  end
  it 'emailなし' do
    user.email = ' '
    expect(user).to be_invalid
  end
  it '名前の文字数が長い' do
    user.name = 'a' * 51
    expect(user).to be_invalid
  end
  it 'emailの文字数が長い' do
    user.name = 'a' * 244 + '@example.com'
    expect(user).to be_invalid
  end
  it 'emailの無効なフォーマット' do
    addresses = %w[
      user@foo,com
      user_at_foo.org
      example.user@foo.
      foo@bar_baz.com
      foo@bar+baz.com
    ]
    addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to be_invalid
    end
  end
  it 'emailの有効なフォーマット' do
    addresses = %w[
      user@foo.COM
      A_US-ER@f.b.org
      frst.lst@foo.jp
      a+b@baz.cn
    ]
    addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end
  it 'emailの大文字小文字を区別しない一意性のテスト' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to be_invalid
  end

  describe 'emailアドレスを小文字変換: before_save' do
    let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }
    it 'should be saved as all lower-case' do
      user.update_attribute(:email, mixed_case_email) # 変えた
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end

  it 'パスワードが空' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to be_invalid
  end
  it 'パスワードが短すぎる' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to be_invalid
  end
  it 'パスワード確認が違う' do
    user.password_confirmation = 'mismatch'
    expect(user).to be_invalid
  end

  describe 'パスワードの認証' do # 7-9?
    # 事前にユーザーをDBに保存
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }
    # userとfound_userのパスワードを比較
    describe '認証の一致' do
      specify { expect(found_user.valid_password?(user.password)).to be true } # 変えた
    end
    describe '認証の不一致' do
      let(:user_for_invalid_password) { found_user.valid_password?('invalid') } # authenticateの代替
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be false } # 変更
    end
  end
  # 9
  it 'ダイジェストが存在しない場合は認証失敗' do
    expect(user.valid_password?('')).to be_falsy
  end
end
