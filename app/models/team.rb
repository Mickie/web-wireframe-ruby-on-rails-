class Team < ActiveRecord::Base
  belongs_to :sport, :inverse_of => :teams
  belongs_to :league, :inverse_of => :teams
  belongs_to :division, :inverse_of => :teams
  belongs_to :conference, :inverse_of => :teams
  belongs_to :affiliation, :inverse_of => :teams
  belongs_to :location
  belongs_to :social_info
  
  validates :name, presence:true
  validates :sport_id, presence:true
  validates :league_id, presence:true
  
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :social_info
end
