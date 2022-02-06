class User < ApplicationRecord
  before_save { email.downcase! } # 6

  # modules
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  # その他 modules
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # 6
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true # 6.3.4
end
