class AddFriendlyIdToUser < ActiveRecord::Migration
  def up
    add_column :users, :slug, :string
    add_index :users, :slug, unique:true
    
    User.find_each(&:save)
  end
  
  def down
    remove_index :users, :slug
    remove_column :users, :slug
  end
end
