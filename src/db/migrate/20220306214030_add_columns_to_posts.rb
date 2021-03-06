class AddColumnsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :address, :string
    add_column :posts, :latitude, :float
    add_column :posts, :longitude, :float
    add_column :posts, :spot_quality, :string # radio
    add_column :posts, :spot_type, :text, array: true # checkbox
  end
end
