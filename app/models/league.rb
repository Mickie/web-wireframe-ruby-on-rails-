class League < ActiveRecord::Base
  belongs_to :sport
  has_many :conferences
  has_many :divisions
  has_many :teams

  attr_accessible :name, :sport_id
  
end
