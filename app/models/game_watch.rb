class GameWatch < ActiveRecord::Base
  belongs_to :event
  belongs_to :venue
  belongs_to :creator, class_name:User
  
  attr_accessible :name, :event_id, :venue_id, :creator_id
  
end
