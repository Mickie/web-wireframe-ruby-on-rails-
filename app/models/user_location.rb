class UserLocation < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_locations
  
  validates :location_query, presence: true

  attr_accessible :location_query
end
