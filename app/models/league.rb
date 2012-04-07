class League < ActiveRecord::Base
  belongs_to :sport
  attr_accessible :name, :sport_id
  
end
