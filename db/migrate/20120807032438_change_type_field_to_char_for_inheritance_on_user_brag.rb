class ChangeTypeFieldToCharForInheritanceOnUserBrag < ActiveRecord::Migration
  def up
    remove_column :user_brags, :type
    add_column :user_brags, :type, :string
  end

  def down
    remove_column :user_brags, :type
    add_column :user_brags, :type, :integer
  end
end
