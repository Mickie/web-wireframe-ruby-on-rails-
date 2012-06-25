class Event < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :visiting_team, :class_name => "Team", :foreign_key => "visiting_team_id"
  belongs_to :location, :dependent => :destroy
  
  has_many :game_watches, inverse_of: :event, :dependent => :delete_all
  has_many :venues, through: :game_watches 
  
  validates :home_team, presence:true
  validates :visiting_team, presence:true
  validates :event_date, presence:true 
  
  accepts_nested_attributes_for :location
  
  attr_accessible :name, :home_team_id, :visiting_team_id, :event_date, :event_time, :location_attributes

end
