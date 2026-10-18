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
  describe '基本の有効性' do
    it { should be_valid }
  end


  describe 'バリデーション' do
    it '名前が空なら無効' do
      user.name = ' '
      expect(user).to be_invalid
    end
    it 'emailが空なら無効' do
      user.email = ' '
      expect(user).to be_invalid
    end
    it '名前の文字数が長いなら無効' do
      user.name = 'a' * 51
      expect(user).to be_invalid
    end
    it 'emailの文字数が長いなら無効' do
      user.email = 'a' * 244 + '@example.com'
      expect(user).to be_invalid
    end
  end

  # 存在性
  it 'emailのフォーマットが無効な場合' do
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
  it 'emailのフォーマットが有効な場合' do
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

  describe 'emailの固有処理' do
    it '大文字小文字を区別せず一意であること' do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user).to be_invalid
    end

    it '保存時に全て小文字変換されること: before_save
    as all lower-case' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.update_attribute(:email, mixed_case_email) # 変えた
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe 'パスワードのバリデーション' do
    it '空またはスペースのみは無効' do
      user.password = user.password_confirmation = ' ' * 6
      expect(user).to be_invalid
    end
    it '短すぎるのは無効' do
      user.password = user.password_confirmation = 'a' * 5
      expect(user).to be_invalid
    end
    it '確認用パスワードと一致しないと無効' do
      user.password_confirmation = 'mismatch'
      expect(user).to be_invalid
    end
  end

  describe 'パスワードの認証' do # 7-9?
    # 事前にユーザーをDBに保存
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }

    # userとfound_userのパスワードを比較
    context '正いパスワードの場合' do
      specify { expect(found_user.valid_password?(user.password)).to be true } # 変えた
    end

    context '間違ったパスワードの場合' do
      let(:user_for_invalid_password) { found_user.valid_password?('invalid') } # authenticateの代替
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be false } # 変更
    end
    # 9
    context 'パスワードが空の場合' do
      it '偽（false）を返すこと' do
        expect(found_user.valid_password?('')).to be_falsy
      end
    end
  end
end
