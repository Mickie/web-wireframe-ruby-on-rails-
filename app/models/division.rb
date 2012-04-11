class Division < ActiveRecord::Base
  belongs_to :league, :inverse_of => :divisions
  has_many :teams, :inverse_of => :division
  
  attr_accessible :name, :league_id

end
