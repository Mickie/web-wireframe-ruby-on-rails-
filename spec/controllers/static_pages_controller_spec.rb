require 'spec_helper'

describe StaticPagesController do
  
  describe "GET 'home'" do
    it "returns http success" do
      mock_geocoding!
      theStubTeam = stub_model(Team, id: 313)
      Team.stub(:find).and_return(theStubTeam)
      theStubTailgate = stub_model(Tailgate, team:theStubTeam)
      Tailgate.stub(:find_by_team_id).and_return(theStubTailgate)
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'channel'" do
    it "returns http success" do
      get 'channel'
      response.should be_success
    end
  end

end
