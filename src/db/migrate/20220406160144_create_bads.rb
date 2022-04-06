class CreateBads < ActiveRecord::Migration[6.1]
  def change
    create_table :bads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :comment_id], unique: true
    end
  end
end
