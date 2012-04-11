class League < ActiveRecord::Base
  belongs_to :sport, :inverse_of => :leagues
  has_many :conferences, :inverse_of => :league
  has_many :divisions, :inverse_of => :league
  has_many :teams, :inverse_of => :league

  attr_accessible :name, :sport_id
  
end
