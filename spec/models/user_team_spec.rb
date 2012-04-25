require 'spec_helper'

describe UserTeam do
  before do
    mock_geocoding!
    @team = FactoryGirl.create(:team)
    @user = FactoryGirl.create(:user)
    @user_team = UserTeam.new(user:@user, team:@team)
  end

  subject { @user_team }
  
  it { should respond_to(:team) }
  it { should respond_to(:user) }
end
