class Division < ActiveRecord::Base
  belongs_to :conference
  attr_accessible :name, :conference_id

end
