class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :address, :string, default: '鶴見緑地'
    add_column :users, :latitude, :float, default: '34.711'
    add_column :users, :longitude, :float, default: '135.581'
  end
end
