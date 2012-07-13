class AddFanScoreToCommentsAndPosts < ActiveRecord::Migration
  def change
    add_column :comments, :fan_score, :integer, default:0
    add_column :posts, :fan_score, :integer, default:0
  end
end
