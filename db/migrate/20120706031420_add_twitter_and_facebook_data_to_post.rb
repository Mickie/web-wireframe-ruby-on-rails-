class AddTwitterAndFacebookDataToPost < ActiveRecord::Migration
  def change
    add_column :posts, :twitter_id, :string
    add_column :posts, :twitter_flag, :boolean
    add_column :posts, :twitter_reply_id, :string
    add_column :posts, :twitter_retweet_id, :string
    add_column :posts, :facebook_flag, :boolean
    add_column :posts, :facebook_id, :string
  end
end
