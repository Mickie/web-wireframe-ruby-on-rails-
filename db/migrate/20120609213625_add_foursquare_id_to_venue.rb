class AddFoursquareIdToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :foursquare_id, :string
  end
end
