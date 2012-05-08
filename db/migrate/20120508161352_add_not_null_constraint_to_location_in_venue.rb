class AddNotNullConstraintToLocationInVenue < ActiveRecord::Migration
  def up
    change_column :venues, :location_id, :integer, :null => false
  end

  def down
    change_column :venues, :location_id, :integer, :null => true
  end
end
