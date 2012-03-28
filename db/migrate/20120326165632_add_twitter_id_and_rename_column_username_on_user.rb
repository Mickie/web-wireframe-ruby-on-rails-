class AddTwitterIdAndRenameColumnUsernameOnUser < ActiveRecord::Migration
  def change

    add_column :users, :twitter_user_id, :string
    rename_column :users, :username, :twitter_username

  end
end
