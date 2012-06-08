class AddFoursquareAndNameDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :foursquare_user_id, :string
    add_column :users, :foursquare_access_token, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :name, :string
    add_column :users, :image, :string 
    add_column :users, :description, :string
    
    add_index :users, :twitter_user_id, :unique => true
    add_index :users, :instagram_user_id, :unique => true    
    add_index :users, :foursquare_user_id, :unique => true    
  end
end
