class TailgateVenue < ActiveRecord::Base
  belongs_to :tailgate
  belongs_to :venue
  attr_accessible :latitude, :longitude, :tailgate, :venue, :tailgate_id, :venue_id
  
  geocoded_by :venue_address
  after_validation :geocode, :if => :venue_address_changed?
  
  def venue_address
    venue.location.one_line_address
  end
  
  def venue_address_changed?
    return venue.location.one_line_address_changed?
  end
  
end
