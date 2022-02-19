class User < ApplicationRecord
  before_save { email.downcase! } # 6

  # modules
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  # その他
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # 6
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # 10 入力必須はユーザー作成(新規登録)の時のみにする
  validates :password, presence: true, on: :create
  # 10 ユーザ編集用 現在のパスワード
  attr_accessor :current_password
end
