class Tailgate < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  validates :name, presence:true
  validates :user_id, presence:true

  attr_accessible :name, :team, :team_id, :user, :user_id
  
end
