require 'spec_helper'

describe UsersController do
  login_user
  
  describe "user profile page" do
    before do
      mock_geocoding!
    end 

    describe "goes to the right locations" do
      before do
        get :show, {id: subject.current_user.to_param}
      end 

      it "should return http success" do
        response.should be_success
      end
  
      it "should send the user to the view" do
        assigns(:user).should eq(subject.current_user)
        assigns(:user_team).should be_a(UserTeam)
        assigns(:user_location).should be_a(UserLocation)
        assigns(:user_location).location.should be_a(Location)
      end
    end
    
    describe "send the right data to the view" do
      before do
        @team = FactoryGirl.create(:team)
        @location = FactoryGirl.create(:location, city:"Dallas", state: State.find_by_abbreviation('TX'))
        subject.current_user.teams.push(@team)
        subject.current_user.locations.push(@location)
        subject.current_user.save
        
        @theFirstWatchSite = FactoryGirl.create(:watch_site, team:@team)
        @theSecondWatchSite = FactoryGirl.create(:watch_site)
        WatchSite.should_receive(:near).exactly(3).times.and_return([@theFirstWatchSite, @theSecondWatchSite])
        
        @theFirstTailgateVenue = TailgateVenue.create tailgate_id:FactoryGirl.create(:tailgate).id, venue_id:@theFirstWatchSite.venue.id
        @theSecondTailgateVenue = TailgateVenue.create tailgate_id:FactoryGirl.create(:tailgate).id, venue_id:@theSecondWatchSite.venue.id
        TailgateVenue.should_receive(:near).twice.and_return([@theFirstTailgateVenue, @theSecondTailgateVenue])

        get :show, {id: subject.current_user.to_param}
      end 

      it "returns all watch sites near location in @localWatchSites" do
        assigns(:localWatchSites).should eq([@theFirstWatchSite, @theSecondWatchSite])
      end

      it "returns the users teams watch sites near their locations in @locationsWithTeamWatchSites" do 
        assigns(:locationsWithTeamWatchSites).should eq([{ "locationName" => "Kirkland, WA", "localTeamWatchSiteList" => [@theFirstWatchSite]}, 
                                                         { "locationName" => "Dallas, TX", "localTeamWatchSiteList" => [@theFirstWatchSite]}])
      end

      it "returns all tailgate venues near users locations in @locationsWithTailgateVenues" do
        assigns(:locationsWithTailgateVenues).should eq([{ "locationName" => "Kirkland, WA", "tailgateVenueList" => [@theFirstTailgateVenue, @theSecondTailgateVenue]}, 
                                                         { "locationName" => "Dallas, TX", "tailgateVenueList" => [@theFirstTailgateVenue, @theSecondTailgateVenue]}])
      end
    end
    
  end

  describe "connect twitter page" do
    before do
      get :connect_twitter, {id: subject.current_user.to_param}
    end

    it "should return http success" do
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(subject.current_user)
    end

  end

  describe "connect instagram page" do
    before do
      get :connect_instagram, { id: subject.current_user.to_param }
    end

    it "should return http success" do
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(subject.current_user)
    end

  end

end
