require 'spec_helper'

describe UserTeam do
  before do
    mock_geocoding!
    @team = FactoryGirl.create(:team)
    @user = FactoryGirl.create(:user)
    @user_team = @user.user_teams.build(team_id:@team.id)
  end

  subject { @user_team }
  
  it { should respond_to(:team) }
  it { should respond_to(:user) }
end
