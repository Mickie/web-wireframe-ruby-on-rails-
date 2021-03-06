class Conference < ActiveRecord::Base
  belongs_to :league, :inverse_of => :conferences
  has_many :teams, :inverse_of => :conference, :dependent => :delete_all
  
  validates :name, presence:true
  validates_associated :teams
  
  attr_accessible :name, :league_id

end
