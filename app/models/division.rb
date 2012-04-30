class Division < ActiveRecord::Base
  belongs_to :league, :inverse_of => :divisions
  has_many :teams, :inverse_of => :division, :dependent => :delete_all

  validates :name, presence:true
  validates_associated :teams
  
  attr_accessible :name, :league_id
end
