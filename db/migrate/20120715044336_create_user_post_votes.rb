class CreateUserPostVotes < ActiveRecord::Migration
  def change
    create_table :user_post_votes do |t|
      t.references :user, null: false
      t.references :post, null: false
      t.boolean :up_vote, default: true

      t.timestamps
    end
    add_index :user_post_votes, :user_id
    add_index :user_post_votes, :post_id
  end
end
