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
      end
    end
    
    describe "send the right data to the view" do
      before do
        @team = FactoryGirl.create(:team)
        subject.current_user.teams.push(@team)
        subject.current_user.save

        @theFirstWatchSite = FactoryGirl.build(:watch_site, team:@team)
        @theSecondWatchSite = FactoryGirl.build(:watch_site)
        WatchSite.should_receive(:near).and_return([@theFirstWatchSite, @theSecondWatchSite])
        
        @theFirstTailgateVenue = TailgateVenue.create tailgate:FactoryGirl.create(:tailgate), venue:@theFirstWatchSite.venue
        @theSecondTailgateVenue = TailgateVenue.create tailgate:FactoryGirl.create(:tailgate), venue:@theSecondWatchSite.venue
        TailgateVenue.should_receive(:near).and_return([@theFirstTailgateVenue, @theSecondTailgateVenue])

        get :show, {id: subject.current_user.to_param}
      end 

      it "returns the users teams watch sites near location in @localTeamWatchSites" do
        assigns(:localTeamWatchSites).should eq([@theFirstWatchSite])
      end

      it "returns all watch sites near location in @localWatchSites" do
        assigns(:localWatchSites).should eq([@theFirstWatchSite, @theSecondWatchSite])
      end

      it "returns all tailgate venues near location in @localTailgateVenues" do
        assigns(:localTailgateVenues).should eq([@theFirstTailgateVenue, @theSecondTailgateVenue])
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
