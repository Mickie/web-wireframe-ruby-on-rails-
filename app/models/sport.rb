class Sport < ActiveRecord::Base
  has_many :leagues
  has_many :teams
  
  attr_accessible :name, :leagues
end
