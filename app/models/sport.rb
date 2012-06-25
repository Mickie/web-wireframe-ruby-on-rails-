class Sport < ActiveRecord::Base
  has_many :leagues, :dependent => :delete_all
  has_many :teams, :dependent => :delete_all
  
  validates :name, uniqueness:true, presence:true
  
  attr_accessible :name
end
