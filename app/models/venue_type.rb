class VenueType < ActiveRecord::Base
  has_many :venues
  validates :name, uniqueness:true, presence:true
  
  attr_accessible :name
end
