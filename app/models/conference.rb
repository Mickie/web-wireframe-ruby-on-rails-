class Conference < ActiveRecord::Base
  belongs_to :league
  has_many :divisions
  attr_accessible :name, :league_id

end
