class VenueType < ActiveRecord::Base
  has_many :venues
  validates :name, uniqueness:true
end
