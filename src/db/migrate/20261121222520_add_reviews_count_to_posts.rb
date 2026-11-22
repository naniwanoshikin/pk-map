class AddReviewsCountToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :reviews_count, :integer, default: 0, null: false
  end
end
