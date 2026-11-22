# frozen_string_literal: true

class Review < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user, counter_cache: true # SQL減らす
  belongs_to :post, counter_cache: true # SQL減らす

  # 高評価
  has_many :goods, dependent: :destroy
  # 低評価
  has_many :bads, dependent: :destroy
  # reviewを高評価したユーザー
  has_many :good_users, through: :goods, source: :user
  # reviewを低評価したユーザー
  # has_many :bad_users, through: :bads, source: :user

  # 通知
  has_many :notifications, dependent: :destroy

  # score : 1 ~ 5 の整数ok / 0 はエラー
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
