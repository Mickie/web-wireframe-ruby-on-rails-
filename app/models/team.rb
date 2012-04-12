class Team < ActiveRecord::Base
  belongs_to :sport, :inverse_of => :teams
  belongs_to :league, :inverse_of => :teams
  belongs_to :division, :inverse_of => :teams
  belongs_to :conference, :inverse_of => :teams
  belongs_to :affiliation, :inverse_of => :teams
  belongs_to :location
  belongs_to :social_info
  
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :social_info
end
