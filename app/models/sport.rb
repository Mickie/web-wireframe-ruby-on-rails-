class Sport < ActiveRecord::Base
  has_many :leagues
  attr_accessible :name, :leagues
end
