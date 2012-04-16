class GameWatch < ActiveRecord::Base
  belongs_to :event
  belongs_to :venue
  belongs_to :creator, class_name:User
end
