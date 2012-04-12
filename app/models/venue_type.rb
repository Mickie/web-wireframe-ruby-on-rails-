class VenueType < ActiveRecord::Base
  validates :name, uniqueness:true
end
