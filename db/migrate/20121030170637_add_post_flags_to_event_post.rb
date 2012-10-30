class AddPostFlagsToEventPost < ActiveRecord::Migration
  def change
    add_column :event_posts, :home_flag, :boolean
    add_column :event_posts, :visiting_flag, :boolean
  end
end
