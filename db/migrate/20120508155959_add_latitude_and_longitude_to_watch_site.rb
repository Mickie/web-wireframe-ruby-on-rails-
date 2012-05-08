class AddLatitudeAndLongitudeToWatchSite < ActiveRecord::Migration
  def change
    add_column :watch_sites, :latitude, :float
    add_column :watch_sites, :longitude, :float
  end
end
