class AddVisibleFlagToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :visible, :boolean, default:false
  end
end
