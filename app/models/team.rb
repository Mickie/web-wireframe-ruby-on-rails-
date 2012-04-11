class Team < ActiveRecord::Base
  belongs_to :sport
  belongs_to :league
  belongs_to :division
  belongs_to :conference
  belongs_to :location
  belongs_to :affiliation
  
  accepts_nested_attributes_for :location
end
