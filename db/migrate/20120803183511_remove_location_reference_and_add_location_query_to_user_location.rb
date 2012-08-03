class RemoveLocationReferenceAndAddLocationQueryToUserLocation < ActiveRecord::Migration
  def up
    remove_index :user_locations, :location_id
    remove_column :user_locations, :location_id
    add_column :user_locations, :location_query, :string, null: false
  end

  def down
    remove_column :user_locations, :location_query
    add_column :user_locations, :location_id, :integer
    add_index :user_locations, :location_id
  end
end
