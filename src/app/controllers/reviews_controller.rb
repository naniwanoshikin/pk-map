# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy good_users]
  before_action :correct_user, only: :destroy
  # レビューのない画面は表示できない
  before_action :correct_review, only: %i[show good_users]

  # レビュー詳細
  def show; end

  # レビューを作成
  def create
    @review = current_user.reviews.build(review_params)
    @post = @review.post

    if @review.save
      handle_create_success
    else
      handle_create_failure
    end
  end

  # レビューを削除
  def destroy
    # @review
    @post = @review.post
    @review.destroy
    @reviews = Review.where(post_id: @post.id)

    respond_to do |format|
      # Rails 7 移行のフォーム/ボタン送信リダイレクト
      format.html { redirect_to @post, alert: 'レビューを削除しました', status: :see_other }
      # JSを介さず、直感的なHTML断片で非同期処理を行う
      format.turbo_stream { flash.now[:alert] = 'レビューを削除しました' }
    end
  end

  # 高評価したユーザー一覧
  def good_users
    # @review
    @review_good_users = @review.good_users.page(params[:page]).per(10)
    # SQL対策 (users/_follow_form)で使用
    @my_relationships = current_user.active_relationships.to_a if user_signed_in?
  end

  private

  # レビュー保存成功時
  def handle_create_success
    # SQL対策 rails8 メモリにセット
    @review.association(:goods).target = []
    @review.association(:bads).target = []
    # 通知
    current_user.notify_to_review!(@post, @review.id)
    # 最新のレビュー一覧 elseのものとは異なる
    @reviews = @post.reviews
    # (reviews/form)
    respond_to do |format|
      format.html { redirect_to @post, notice: 'レビューを追加しました' }
      format.turbo_stream { flash.now[:notice] = 'レビューを追加しました' }
    end
  end

  # レビューの保存失敗 (星0のとき)
  def handle_create_failure
    # 実際のレビュー一覧
    @reviews = Review.where(post_id: @post.id)
    flash.now[:alert] = 'レビュー投稿に失敗しました'

    respond_to do |format|
      format.html { render 'posts/show', status: :unprocessable_content }
      format.turbo_stream { render status: :unprocessable_content }
    end
  end

  def review_params
    # (posts/show)
    params.expect(
      review: %i[
        post_id
        score
        content
      ]
    )
  end

  # destroy
  def correct_user
    @review = current_user.reviews.find_by(id: params[:review_id]) # (reviews/review)
    redirect_to root_url if @review.nil?
  end

  # show, good_users
  def correct_review
    @review = Review.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @review.nil?
  end
end
