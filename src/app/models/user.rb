# frozen_string_literal: true

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
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? && obj.errors.blank? }

  # --- 3. アソシエーション ---------------
  # 投稿 / レビュー / userがレビューした投稿
  has_many :posts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :review_posts, -> { distinct }, through: :reviews, source: :post

  # 高評価 / 低評価
  has_many :goods, dependent: :destroy
  has_many :bads, dependent: :destroy
  # userが高評価 / 低評価したレビュー
  # has_many :good_reviews, through: :goods, source: :review
  # has_many :bad_reviews, through: :bads, source: :review

  # フォローする
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id',
                                  dependent: :destroy, inverse_of: :follower
  has_many :following, through: :active_relationships, source: :followed
  # フォローされる
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id',
                                   dependent: :destroy, inverse_of: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # 自分からの通知 / 相手からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id',
                                  dependent: :destroy, inverse_of: :visitor
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id',
                                   dependent: :destroy, inverse_of: :visited

  # --- 4. 属性・バリデーション ---------------
  # 10 ユーザ編集用 現在のパスワード
  attr_accessor :current_password

  # 6
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # 10 入力必須はユーザー登録時のみにする
  validates :password, presence: true, on: :create, allow_nil: true

  # --- 5. クラスメソッド（ゲストログイン）  ---------------
  class << self
    # Sessions(C)
    def guest1
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
  # HomePages(C)_home @feeds = user.feed
  def feed
    # サブクエリ: 自身がフォローしているユーザー&自身の投稿
    following_ids = 'SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id'
    # メインクエリ ()で埋め込んでるのがサブクエリ
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  # selfがuserをフォロー Relationship(C)
  def follow(user)
    following << user
  end

  # selfがuserをフォロー解除 Relationship(C)
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  # selfがuserをフォローしてたらtrue テストで使う？
  # def following?(user)
  #   following.include?(user)
  # end

  # ------------------------------
  # userがreviewを高,低評価 / Goods,Bads(C) (seeds.rb)
  def good(review)
    goods.create(review: review)
  end

  def bad(review)
    bads.create(review: review)
  end

  # selfがreviewを評価してたらtrue (goods/good) (bads/bad)
  def good?(review)
    review.goods.any? { |good| good.user_id == id }
  end

  def bad?(review)
    review.bads.any? { |bad| bad.user_id == id }
  end

  # 高評価, 低評価を解除 / Goods(C), Bads(C)
  # def ungood(review)
  #   goods.find_by(review_id: review.id)&.destroy
  # end

  # def unbad(review)
  #   bads.find_by(review_id: review.id)&.destroy
  # end

  # --- 7. 通知 ---------------

  # selfがuserにフォローを通知 Relationships(C)
  def notify_to_follow!(user)
    # 過去にuserへのフォロー通知があれば、ここで処理終了 = 「ボタン連打」への備え
    return if active_notifications.exists?(visited_id: user.id, action: 'follow')

    # なければ、userに通知を作成/保存
    active_notifications.create(visited_id: user.id, action: 'follow')
  end

  # selfがそのpostをしたユーザーにreviewを通知 複数回通知可 Reviews(C), seed
  def notify_to_review!(post, review_id)
    # そのpostにレビューしたことのある自分以外のユーザーid
    visitor_ids = post.reviews.where.not(user_id: id).unscope(:order).distinct.pluck(:user_id)
    # 通知を送る相手のIDリスト 自分の投稿へは除外
    # そのpostの過去のレビュアー全員へ、誰もレビューしていなければ投稿者へ
    target_ids = (visitor_ids.presence || [post.user_id]) - [id]
    return if target_ids.empty?

    # 投稿者に「あなたの投稿にレビューがつきました」
    # 過去のレビュワー全員に「あなたがレビューした投稿に、新しく別のレビューが追加されました」
    notifications = target_ids.map do |visited_id|
      {
        visitor_id: id,         # 自分
        visited_id: visited_id, # レビュー先の投稿ユーザー
        post_id: post.id,       # レビュー先の投稿
        review_id: review_id,   # レビューid
        action: 'review',
        checked: false          # 未読
      }
    end
    # 通知を保存 集めた配列を1回のSQLでまとめてDBへ登録
    # rubocop:disable-next Rails/SkipsModelValidations
    Notification.insert_all(notifications)
  end

  # selfがreview したユーザーにGood評価を通知 Goods(C)
  def notify_to_good!(review)
    # 1. 自分のreviewに対してのgood評価したなら、即終了（自分への通知を防ぐ）
    return if id == review.user_id

    # 2. 過去にreviewに対するgood通知が存在するなら、即終了（ボタン連打対策）
    # review.user_id, # 評価されたレビューのユーザー
    # review.id,      # 評価されたレビューのid
    return if active_notifications.exists?(visited_id: review.user_id, review_id: review.id, action: 'good')

    # 3. 通知を作成/保存
    active_notifications.create(visited_id: review.user_id, review_id: review.id, action: 'good')
  end
end
