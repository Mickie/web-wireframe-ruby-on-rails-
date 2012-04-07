class League < ActiveRecord::Base
  belongs_to :sport
  has_many :conferences
  has_many :divisions

  attr_accessible :name, :sport_id
  
end
