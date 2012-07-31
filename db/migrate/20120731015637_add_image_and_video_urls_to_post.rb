class AddImageAndVideoUrlsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :image_url, :string
    add_column :posts, :video_url, :string
  end
end
