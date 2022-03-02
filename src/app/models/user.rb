class User < ApplicationRecord
  before_save { email.downcase! } # 6

  # 投稿
  has_many :posts, dependent: :destroy

  # フォローする
  has_many :active_relationships, class_name: "Relationship",
    foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  # フォローされる
  has_many :passive_relationships, class_name:  "Relationship",
  foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification',
  foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification',
  foreign_key: 'visited_id', dependent: :destroy

  # modules
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  # :confirmable
  # その他
  # :lockable, :timeoutable, :trackable and :omniauthable

  # 6
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # 10 入力必須はユーザー作成(新規登録)の時のみにする
  validates :password, presence: true, on: :create, allow_nil: true
  # 10 ユーザ編集用 現在のパスワード
  attr_accessor :current_password

  # ゲストログイン
  def self.guest
    find_by!(email: 'guest@railstutorial.org') do |user|
      user.password = 'foobar'
    end
  end


  # フィード
  def feed
    part_of_feed = "
    relationships.follower_id = :id
    or posts.user_id = :id
    "
    Post.left_outer_joins(user: :followers)
    .where(part_of_feed, { id: id }).distinct
    .includes(:user)
  end

  # selfがother_userをフォロー
  def follow(other_user) # Relationship(C)
    following << other_user
  end
  # selfがother_userをフォロー解除
  def unfollow(other_user) # Relationship(C)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  # selfがother_userをフォローしてたらtrue
  def following?(other_user) # (users/_follow_form)
    following.include?(other_user)
  end

  # 通知レコードを作成 (userがフォローする)
  def create_notification_follow!(user) # Relationships(C)
    # 検索レコード
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and action = ? ",
      user.id,  # フォローする人
      id,       # フォローされる人
      'follow'
    ])
    if temp.blank?
      notification = user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

end
