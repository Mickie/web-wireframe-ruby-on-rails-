class Venue < ActiveRecord::Base
  belongs_to :social_info
  belongs_to :location
  belongs_to :venue_type

  validates :name, uniqueness:true, presence:true
  validates :venue_type, presence:true

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :social_info
end
