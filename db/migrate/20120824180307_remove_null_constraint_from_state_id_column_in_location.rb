class RemoveNullConstraintFromStateIdColumnInLocation < ActiveRecord::Migration
  def up
    change_column :locations, :state_id, :integer, :null => true
  end

  def down
    change_column :locations, :state_id, :integer, :null => false
  end
end
