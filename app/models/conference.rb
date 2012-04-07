class Conference < ActiveRecord::Base
  belongs_to :league
  attr_accessible :name, :league_id

end
