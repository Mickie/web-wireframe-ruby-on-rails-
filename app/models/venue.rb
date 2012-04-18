class Venue < ActiveRecord::Base
  belongs_to :social_info
  belongs_to :location
  belongs_to :venue_type
  
  has_many :game_watches, inverse_of: :venue
  has_many :events, through: :game_watches   

  has_many :watch_sites, inverse_of: :venue
  has_many :teams, through: :watch_sites   

  validates :name, uniqueness:true, presence:true
  validates :venue_type, presence:true

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :social_info
end
