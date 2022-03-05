class User < ApplicationRecord
  before_save { email.downcase! } # 6
  # 投稿
  has_many :posts, dependent: :destroy
  # いいね
  has_many :likes, dependent: :destroy
  # userがいいねした投稿
  has_many :like_posts, through: :likes, source: :post

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
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # 10 入力必須はユーザー作成(新規登録)の時のみにする
  validates :password, presence: true, on: :create, allow_nil: true
  # 10 ユーザ編集用 現在のパスワード
  attr_accessor :current_password

  # _______________________________________________
  # ゲストログイン
  def self.guest
    find_by!(email: 'guest@railstutorial.org') do |user|
      user.password = 'foobar'
    end
  end

  # _______________________________________________
  # フィード
  def feed
    # - 自身がフォローしているユーザー
    # - 自身
    part_of_feed = "
    relationships.follower_id = :id
    or posts.user_id = :id
    "
    Post.left_outer_joins(user: :followers)
    .where(part_of_feed, { id: id }).distinct
    .includes(:user)
  end

  # _______________________________________________
  # selfがuserをフォロー
  def follow(user) # Relationship(C)
    following << user
  end
  # selfがuserをフォロー解除
  def unfollow(user) # Relationship(C)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  # selfがuserをフォローしてたらtrue
  def following?(user) # (users/_follow_form)
    following.include?(user)
  end

  # _______________________________________________
  # selfがuserにフォロー通知する
  def notify_to_follow!(user) # Relationships(C)
    # レコードを検索 「ボタン連打」に備える
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and action = ? ",
      id,      # フォローする
      user.id, # フォローされる
      'follow'
    ])
    if temp.blank?
      notification = self.active_notifications.new(
        visited_id: user.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # _______________________________________________
  # userがpostをいいねする
  def like(post) # Likes(C)
    likes.create(post_id: post.id)
  end
  # いいね解除
  def unlike(post)
    likes.find_by(post_id: post.id).destroy
  end
  # selfがpostをいいねしてたらtrue
  def like?(post)
    like_posts.include?(post)
  end

  # _______________________________________________
  # selfがpost.userにいいね通知する
  def like_and_notify!(post) # Likes(C)
    # 既にいいねされているか検索 「ボタン連打」に備える
    temp = Notification.where([
      "visitor_id = ? and visited_id = ?
      and post_id = ? and action = ? ",
      id,           # いいねしたユーザー
      post.user_id, # いいねされるユーザー
      post.id,      # いいねした投稿id
      'like'
    ])
    # 通知されていない場合
    if temp.blank?
      notification = self.active_notifications.new(
        visited_id: post.user_id,
        post_id: post.id,
        action: 'like'
      )
      # 無効な通知 or 自分の投稿へのいいねは除く
      return if notification.invalid? || notification.visitor_id == notification.visited_id
      # 通知する
      notification.save
    end
  end
end
