class League < ActiveRecord::Base
  belongs_to :sport, :inverse_of => :leagues
  has_many :conferences, :inverse_of => :league, :dependent => :delete_all
  has_many :divisions, :inverse_of => :league, :dependent => :delete_all
  has_many :teams, :inverse_of => :league, :dependent => :delete_all

  validates :name, presence:true
  validates_associated :teams
  validates_associated :conferences
  validates_associated :divisions


  attr_accessible :name, :sport_id
end
