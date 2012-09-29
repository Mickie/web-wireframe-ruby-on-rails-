class AddLocationDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :hometown, :string
    add_column :users, :location, :string
  end
end
