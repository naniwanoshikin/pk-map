class User < ApplicationRecord
  before_save { email.downcase! } # 6
  # 投稿
  has_many :posts, dependent: :destroy
  # コメント
  has_many :comments, dependent: :destroy
  # userがコメントした投稿
  has_many :comment_posts, through: :comments, source: :post

  # 高評価
  has_many :goods, dependent: :destroy
  # 低評価
  has_many :bads, dependent: :destroy
  # userが高評価したコメント
  has_many :good_comments, through: :goods, source: :comment
  # userが低評価したコメント
  has_many :bad_comments, through: :bads, source: :comment

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

  # 10 入力必須はユーザー登録時のみにする
  validates :password, presence: true, on: :create, allow_nil: true
  # 10 ユーザ編集用 現在のパスワード
  attr_accessor :current_password

  # addressが登録されたら, 緯度経度も自動登録
  geocoded_by :address # 緯度経度を算出
  after_validation :geocode # 住所変更時に緯度経度も変更

  # _______________________________________________
  # ゲストログイン
  def self.guest1 # Sessions(C)
    find_or_create_by!(email: 'example@railstutorial.org') do |user|
      # なければ下記の値になる
      user.name = 'ジェイポ'
      user.password = 'foobar'
      user.address = '梅田'
      user.admin = true
    end
  end
  def self.guest2
    find_or_create_by!(email: 'example-1@railstutorial.org') do |user|
      user.name = 'ドームトマト'
      user.password = 'foobar'
      user.address = '後楽園ホール'
    end
  end
  def self.guest3
    find_or_create_by!(email: 'example-4@railstutorial.org') do |user|
      user.name = 'アロヤーン'
      user.password = 'password'
      user.address = '東淀川'
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
  # selfがuserにフォローを通知する
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
  # selfがpostユーザーにcommentを通知
  def notify_to_comment!(post, comment_id) # Comments(C), seed
    # 自分以外にコメントしている人の投稿集id
    temp_ids = Comment.select(:user_id, :created_at).where(post_id: post.id).where.not(user_id: id).distinct

    # 誰もコメントしていない場合
    if temp_ids.blank?
      save_notify_comment!(post, comment_id, post.user_id)
    else
      # 既にコメントしている人がいる場合
      temp_ids.each do |temp_id|
        save_notify_comment!(post, comment_id, temp_id['user_id'])
      end
    end
  end

  # postへのcommentをvisited_idに通知
  def save_notify_comment!(post, comment_id, visited_id)
    # 同じ投稿に複数回通知可
    notification = self.active_notifications.new(
      visited_id: visited_id, # コメント先の投稿ユーザー
      post_id: post.id,       # コメント先の投稿
      comment_id: comment_id, # コメントid
      action: 'comment'
    )
    # 無効な通知 or 自分の投稿へのコメントは除く
    return if notification.invalid? || notification.visitor_id == notification.visited_id
    # 通知
    notification.save
  end

  # _______________________________________________
  # userがcommentを高評価する
  def good(comment) # (C)
    goods.create(comment_id: comment.id)
  end
  # 高評価を解除
  def ungood(comment)
    goods.find_by(comment_id: comment.id).destroy
  end
  # selfがcommentを高評価してたらtrue
  def good?(comment) # (goods/good)
    good_comments.include?(comment)
  end
  # _______________________________________________
  # userがcommentを低評価
  def bad(comment) # bads(C)
    bads.create(comment_id: comment.id)
  end
  # 低評価を解除
  def unbad(comment)
    bads.find_by(comment_id: comment.id).destroy
  end
  # selfがcommentを低評価してたらtrue
  def bad?(comment) # (bads/bad)
    bad_comments.include?(comment)
  end

  # _______________________________________________
  # selfがcomment.userへ高評価を通知
  def notify_to_good!(comment) # Goods(C)
    # 既に高評価されているか検索 「ボタン連打」に備える
    temp = Notification.where([
      "visitor_id = ? and visited_id = ?
      and comment_id = ? and action = ? ",
      id,           # 高評価したユーザー
      comment.user_id, # 高評価されるユーザー
      comment.id,      # 高評価した投稿id
      'good'
    ])
    # 通知されていない場合
    if temp.blank?
      notification = self.active_notifications.new(
        visited_id: comment.user_id,
        comment_id: comment.id,
        action: 'good'
      )
      # 無効な通知 or 自分の投稿への高評価は除く
      return if notification.invalid? || notification.visitor_id == notification.visited_id
      # 通知する
      notification.save
    end
  end
end
