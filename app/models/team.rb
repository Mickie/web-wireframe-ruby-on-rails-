class Team < ActiveRecord::Base

  belongs_to :sport, :inverse_of => :teams
  belongs_to :league, :inverse_of => :teams
  belongs_to :division, :inverse_of => :teams
  belongs_to :conference, :inverse_of => :teams
  belongs_to :affiliation, :inverse_of => :teams
  belongs_to :location, :dependent => :destroy
  belongs_to :social_info, :dependent => :destroy
  
  has_many :home_games, class_name:"Event", foreign_key:"home_team_id", inverse_of: :home_team, :dependent => :delete_all, order: "event_date"
  has_many :away_games, class_name:"Event", foreign_key:"visiting_team_id", inverse_of: :visiting_team, :dependent => :delete_all, order: "event_date"
  has_many :athletes, inverse_of: :team, :dependent => :delete_all
  has_many :coaches, inverse_of: :team, :dependent => :delete_all
  has_many :journalists, inverse_of: :team, :dependent => :delete_all
  has_many :superfans, inverse_of: :team, :dependent => :delete_all
  has_many :tailgates, inverse_of: :team 
   
  has_many :watch_sites, inverse_of: :team, :dependent => :delete_all
  has_many :venues, through: :watch_sites 
   
  validates :name, presence:true
  validates :sport_id, presence:true
  validates :league_id, presence:true
  
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :social_info
  
  attr_accessible :name, 
                  :sport_id, 
                  :league_id, 
                  :division_id, 
                  :conference_id, 
                  :affiliation_id, 
                  :location_attributes,
                  :social_info_attributes
                  
  default_scope order: "name"
  
  def events
    theEvents = self.home_games + self.away_games
    theEvents.sort_by {|e| e[:event_date] }
  end
  
end
