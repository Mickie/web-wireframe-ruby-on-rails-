class RemoveUniqueNameConstraintFromLeague < ActiveRecord::Migration
  def up
    remove_index :leagues, :name
  end

  def down
    add_index :leagues, :name, :unique => true
  end
end
