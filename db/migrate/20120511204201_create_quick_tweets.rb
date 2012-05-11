class CreateQuickTweets < ActiveRecord::Migration
  def change
    create_table :quick_tweets do |t|
      t.references :sport
      t.string :name, null:false
      t.string :tweet, null:false
      t.boolean :happy, default:true

      t.timestamps
    end
    add_index :quick_tweets, :sport_id
  end
end
