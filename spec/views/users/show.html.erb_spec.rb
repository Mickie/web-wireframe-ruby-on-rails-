require 'spec_helper'

describe "users/show" do
  before(:each) do
    mock_geocoding!
    
    @user = assign(:user, stub_model(User,
      :email => "joe@foo.com"
    ))
    @user_team = assign(:user_team, stub_model(UserTeam,
      :user_id => 1
    ))
    
    theTeam = FactoryGirl.create(:team)
    theVenue = FactoryGirl.create(:venue)
    theTailgate = FactoryGirl.create(:tailgate)
    theWatchSite = FactoryGirl.build(:watch_site, team: theTeam, venue: theVenue)
    theTailgateVenue = TailgateVenue.new venue:theVenue, tailgate:theTailgate
    @localTeamWatchSites = assign(:localTeamWatchSites, [theWatchSite])
    @localWatchSites = assign(:localTeamWatchSites, [theWatchSite])
    @localTailgateVenues = assign(:localTailgateVenues, [theTailgateVenue])
    
  end

  it "should be the parking lot" do
    render
    rendered.should match(/parking lot/i)
  end 
  
  describe "partials" do
    
    it "should show team picker for new user" do
      render
      view.should render_template(partial:"_team_picker")
    end
    
    describe "with existing user" do
      before do
        mock_geocoding!
        @user = assign(:user, stub_model(User,
          email: "bar@foo.com",
          teams: [FactoryGirl.create(:team), FactoryGirl.create(:team)]
        ))
        render
      end
      
      it "should show the users teams" do
        rendered.should match(/#{@user.teams[0].name}/)
        rendered.should match(/#{@user.teams[1].name}/)
      end
    end
  end
end
