class AddInstagramUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :instagram_username, :string
  end
end
