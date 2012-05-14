class AddInstagramDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :instagram_user_id, :string
    add_column :users, :instagram_user_token, :string
  end
end
