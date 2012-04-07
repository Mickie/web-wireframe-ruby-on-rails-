class League < ActiveRecord::Base
  belongs_to :sport
  has_many :conferences
  attr_accessible :name, :sport_id
  
end
