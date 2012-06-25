class UserLocation < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_locations
  belongs_to :location, :dependent => :destroy

  accepts_nested_attributes_for :location
  
  attr_accessible :location_attributes
end
