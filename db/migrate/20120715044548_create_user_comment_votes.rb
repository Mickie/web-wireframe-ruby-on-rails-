class CreateUserCommentVotes < ActiveRecord::Migration
  def change
    create_table :user_comment_votes do |t|
      t.references :user, null: false
      t.references :comment, null: false
      t.boolean :up_vote, default: true

      t.timestamps
    end
    add_index :user_comment_votes, :user_id
    add_index :user_comment_votes, :comment_id
  end
end
