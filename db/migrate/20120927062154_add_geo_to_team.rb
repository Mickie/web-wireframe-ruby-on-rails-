class AddGeoToTeam < ActiveRecord::Migration
  def up
    add_column :teams, :latitude, :float
    add_column :teams, :longitude, :float
    
    Team.includes(:location).all.each do |aTeam|
      if aTeam.location_id
        aTeam.latitude = aTeam.location.latitude
        aTeam.longitude = aTeam.location.longitude
        aTeam.save
      end
    end
  end

  def down
    remove_column :teams, :latitude
    remove_column :teams, :longitude
  end
end
