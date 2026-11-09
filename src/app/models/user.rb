class User < ApplicationRecord
  # --- 1. 外部拡張 / マクロ定義 -------------
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  # :confirmable

  # addressが登録されたら, 緯度経度も自動登録
  geocoded_by :address # 緯度経度を算出

  # --- 2. コールバック ---------------
  before_save { email.downcase! } # 6

  # 住所変更時に緯度経度も変更 addressが変更されたときのみ かつ他のバリデーションに失敗していない場合のみ
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? && obj.errors.blank? }

  # --- 3. アソシエーション ---------------
  # 投稿 / レビュー / userがレビューした投稿
  has_many :posts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :review_posts, -> { distinct }, through: :reviews, source: :post

  # 高評価 / 低評価 / userが高評価したレビュー / userが低評価したレビュー
  has_many :goods, dependent: :destroy
  has_many :bads, dependent: :destroy
  has_many :good_reviews, through: :goods, source: :review
  has_many :bad_reviews, through: :bads, source: :review

  # フォローする
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  # フォローされる
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # 自分からの通知 / 相手からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # --- 4. 属性・バリデーション ---------------
  # 10 ユーザ編集用 現在のパスワード
  attr_accessor :current_password
  # 6
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # 10 入力必須はユーザー登録時のみにする
  validates :password, presence: true, on: :create, allow_nil: true

  # --- 5. クラスメソッド（ゲストログイン）  ---------------
  class << self
    def guest1 # Sessions(C)
      find_or_create_by!(email: 'example@railstutorial.org') do |user|
        # なければ下記の値になる
        user.name = 'ジェイポ'
        user.password = 'foobar'
        user.address = '梅田'
        user.admin = true
      end
    end
    def guest2
      find_or_create_by!(email: 'example-1@railstutorial.org') do |user|
        user.name = 'ドームトマト'
        user.password = 'foobar'
        user.address = '後楽園ホール'
      end
    end
    def guest3
      find_or_create_by!(email: 'example-4@railstutorial.org') do |user|
        user.name = 'アロヤーン'
        user.password = 'password'
        user.address = '東淀川'
      end
    end
  end

  # --- 6. インスタンスメソッド ---------------
  # フィード
  def feed # HomePages(C)
    # - 自身がフォローしているユーザー
    # - 自身
    Post.left_outer_joins(user: :followers)
    .where("
    relationships.follower_id = :id
    or posts.user_id = :id
    ", { id: id })
    .distinct
    .includes(:user)
  end

  # selfがuserをフォロー
  def follow(user) # Relationship(C)
    following << user
  end
  # selfがuserをフォロー解除
  def unfollow(user) # Relationship(C)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end
  # selfがuserをフォローしてたらtrue
  def following?(user) # (users/_follow_form)
    following.include?(user)
  end

  # ------------------------------
  # userがreviewを高評価する
  def good(review) # (C)
    goods.create(review_id: review.id)
  end
  # 高評価を解除
  def ungood(review)
    goods.find_by(review_id: review.id)&.destroy
  end
  # selfがreviewを高評価してたらtrue
  def good?(review) # (goods/good)
    good_reviews.include?(review)
  end

  # userがreviewを低評価する
  def bad(review) # (C)
    bads.create(review_id: review.id)
  end
  # 低評価を解除
  def unbad(review)
    bads.find_by(review_id: review.id)&.destroy
  end
  # selfがreviewを低評価してたらtrue
  def bad?(review) # (bads/bad)
    bad_reviews.include?(review)
  end

  # --- 7. 通知 ---------------

  # selfがuserにフォローを通知
  def notify_to_follow!(user) # Relationships(C)
    # 過去にuserへのフォロー通知があれば、ここで処理終了 = 「ボタン連打」への備え
    return if self.active_notifications.exists?(visited_id: user.id, action: 'follow')
    # なければ、userに通知を作成/保存する
    self.active_notifications.create(visited_id: user.id, action: 'follow')
  end

  # selfがpostユーザーにreviewを通知
  def notify_to_review!(post, review_id) # Reviews(C), seed
    # そのpostにレビューしたことのある自分以外のユーザーid
    visitor_ids = Review.where(post_id: post.id).where.not(user_id: id).unscope(:order).distinct.pluck(:user_id)

    # そのpostに誰もレビューしていない場合
    if visitor_ids.blank?
      # 「投稿した本人（post.user_id）」に「あなたの投稿にレビューがつきましたよ」と通知
      save_notify_review!(post, review_id, post.user_id)
    else
      # そのpostに過去にすでに他の人がレビューしている場合
      visitor_ids.each do |visited_id|
        # •過去にレビューを書いた全員（`visited_id`）に対して、「あなたがレビューした投稿に、新しく別のレビューが追加されました」と通知
        save_notify_review!(post, review_id, visited_id)
      end
    end
  end

  # postへのreviewを投稿ユーザーに通知
  def save_notify_review!(post, review_id, visited_id)
    return if self.id == visited_id # 自分の投稿へのレビュー通知は除外
    # 同じ投稿に複数回通知可
    notification = self.active_notifications.new(
      visited_id: visited_id, # レビュー先の投稿ユーザー
      post_id: post.id,       # レビュー先の投稿
      review_id: review_id,   # レビューid
      action: 'review'
    )
    # 通知 無効な通知は除く
    notification.save if notification.valid?
  end


  # selfがreview したユーザーにGood評価を通知
  def notify_to_good!(review) # Goods(C)
    # 1. 自分のreviewに対してのgood評価したなら、即終了（自分への通知を防ぐ）
    return if id == review.user_id
    # 2. 過去にreviewに対するgood通知が存在するなら、即終了（ボタン連打対策）
    return if self.active_notifications.exists?(visited_id: review.user_id, review_id: review.id, action: 'good')
    # review.user_id, # 評価されたレビューのユーザー
    # review.id,      # 評価されたレビューのid
    # 3. 通知を作成/保存
    self.active_notifications.create(visited_id: review.user_id, review_id: review.id, action: 'good')
  end
end
