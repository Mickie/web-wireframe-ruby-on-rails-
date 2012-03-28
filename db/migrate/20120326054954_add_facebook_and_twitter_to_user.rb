class AddFacebookAndTwitterToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_user_token, :string
    add_column :users, :twitter_user_secret, :string
    add_column :users, :facebook_user_id, :string
    add_column :users, :facebook_access_token, :string

    add_index :users, :twitter_user_token, :unique => true
    add_index :users, :facebook_user_id, :unique => true

  end
end
