class AddCachesToTailgate < ActiveRecord::Migration
  def change
    add_column :tailgates, :posts_updated_at, :timestamp
    add_column :tailgates, :tailgate_followers_count, :integer, default: 0, null: false

    Tailgate.includes(:posts).all.each do |aTailgate|
      Tailgate.update_counters aTailgate.id, tailgate_followers_count: aTailgate.tailgate_followers.size
      aTailgate.posts_updated_at = aTailgate.posts.any? ? aTailgate.posts[0].updated_at : aTailgate.update_at
      aTailgate.save
    end
  end
end
