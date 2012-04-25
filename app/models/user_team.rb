class UserTeam < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_teams
  belongs_to :team
  
  validates :team_id, presence:true
  validates :user_id, presence:true
end
