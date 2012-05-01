class RemoveNotNullConstraintFromEventTime < ActiveRecord::Migration
  def up
    change_column :events, :event_time, :time, :null => true
  end

  def down
    change_column :events, :event_time, :time, :null => false
  end
end
