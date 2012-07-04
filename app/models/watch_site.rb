class WatchSite < ActiveRecord::Base
  belongs_to :team
  belongs_to :venue
  
  geocoded_by :venue_address
  after_validation :geocode, :if => :venue_address_changed?
  
  attr_accessible :name, :team_id, :venue_id
  
  def venue_address
    venue.location.one_line_address
  end
  
  def venue_address_changed?
    return venue.location.one_line_address_changed? || latitude != venue.location.latitude || longitude != venue.location.longitude
  end
  
end
