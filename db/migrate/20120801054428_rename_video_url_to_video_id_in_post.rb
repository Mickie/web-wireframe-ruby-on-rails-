class RenameVideoUrlToVideoIdInPost < ActiveRecord::Migration
  def change
    rename_column :posts, :video_url, :video_id
  end
end
