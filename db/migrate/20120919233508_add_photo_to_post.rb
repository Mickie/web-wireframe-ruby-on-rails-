class AddPhotoToPost < ActiveRecord::Migration
  def change
    add_column :posts, :photo_id, :integer
    add_index :posts, :photo_id
  end
end
