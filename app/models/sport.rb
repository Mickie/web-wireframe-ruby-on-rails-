class Sport < ActiveRecord::Base
  has_many :leagues
  has_many :teams
  
  validates :name, uniqueness:true
  
  attr_accessible :name, :leagues
end
