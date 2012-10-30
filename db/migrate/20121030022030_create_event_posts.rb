class CreateEventPosts < ActiveRecord::Migration
  def change
    create_table :event_posts do |t|
      t.references :visiting_post
      t.references :home_post
      t.references :event, null: false

      t.timestamps
    end
    add_index :event_posts, :visiting_post_id
    add_index :event_posts, :home_post_id
    add_index :event_posts, :event_id
  end
end
