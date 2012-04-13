class Event < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :visiting_team, :class_name => "Team", :foreign_key => "visiting_team_id"
  belongs_to :location
  
  validates :home_team, presence:true
  validates :visiting_team, presence:true
  validates :event_date, presence:true
  validates :event_time, presence:true
  
  accepts_nested_attributes_for :location

end
