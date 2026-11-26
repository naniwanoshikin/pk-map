# frozen_string_literal: true

class Review < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user, counter_cache: true # SQL対策
  belongs_to :post, counter_cache: true # SQL対策

  # 高評価 / 低評価 / 通知 | delete_all SQL対策
  has_many :goods, dependent: :delete_all
  has_many :bads, dependent: :delete_all
  has_many :notifications, dependent: :delete_all
  # reviewを高評価したユーザー seedのみ
  has_many :good_users, through: :goods, source: :user


  # score : 1 ~ 5 の整数ok / 0 はエラー
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
