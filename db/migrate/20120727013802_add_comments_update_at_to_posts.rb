class AddCommentsUpdateAtToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :comments_updated_at, :timestamp, default:"now()"
    
    Post.includes(:comments).all.each do | aPost |
      aPost.comments_updated_at = aPost.comments.any? ? aPost.comments.last.created_at : aPost.created_at
      aPost.save
    end
    
    Tailgate.includes(:posts).all.each do |aTailgate|
      Tailgate.reset_counters( aTailgate.id, :tailgate_followers )
      aTailgate.posts_updated_at = aTailgate.posts.any? ? aTailgate.posts.first.comments_updated_at : aTailgate.created_at
      aTailgate.save
    end
    
  end
  
  def down
    remove_column :posts, :comments_updated_at
  end
end
