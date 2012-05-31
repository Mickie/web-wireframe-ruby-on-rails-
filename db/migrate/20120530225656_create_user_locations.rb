class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.references :user
      t.references :location

      t.timestamps
    end
    add_index :user_locations, :user_id
    add_index :user_locations, :location_id
  end
end
