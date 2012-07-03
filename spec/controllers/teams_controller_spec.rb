require 'spec_helper'

describe TeamsController do
  
  before do
    mock_geocoding!

    @league = FactoryGirl.create(:league)
    @location = FactoryGirl.build(:location)
    @social_info = FactoryGirl.build(:social_info)
  end

  def valid_attributes
    { 
      name:'Seahawks', 
      league_id:@league.id, 
      sport_id:@league.sport.id, 
      location_attributes: accessible_attributes(Location, @location),
      social_info_attributes: accessible_attributes(SocialInfo, @social_info)
    }
  end
  
  describe "GET index" do
    login_user
    it "assigns all teams as @teams when no sport_id" do
      team = Team.create! valid_attributes
      get :index, {}
      assigns(:teams).should eq([team])
    end
    
    it "assigns teams for a specific sport when sport_id" do
      theFirstTeam = Team.create! valid_attributes
      theSecondTeam = FactoryGirl.create(:team)
      get :index, {sport_id: theSecondTeam.sport_id} 
      assigns(:teams).should eq([theSecondTeam])
    end

    it "assigns teams for a specific league when league_id" do
      theFirstTeam = Team.create! valid_attributes
      theSecondTeam = FactoryGirl.create(:team)
      get :index, {league_id: theSecondTeam.league_id} 
      assigns(:teams).should eq([theSecondTeam])
    end

  end

  describe "GET show" do
    login_user
    
    before do
      @team = Team.create! valid_attributes
    end
    
    describe "assigns appropriate view variables" do
      before do
        get :show, {:id => @team.to_param}
      end
      
      it "assigns the requested team as @team" do
        assigns(:team).should eq(@team)
      end
      
    end      
    
    it "returns the teams watch sites near location in @localTeamWatchSites" do
      theFirstWatchSite = FactoryGirl.build(:watch_site, team:@team)
      theSecondWatchSite = FactoryGirl.build(:watch_site)
      WatchSite.should_receive(:near).and_return([theFirstWatchSite, theSecondWatchSite])
      get :show, {:id => @team.to_param}
      assigns(:localTeamWatchSites).should eq([theFirstWatchSite])
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new team as @team" do
      get :new, {}
      assigns(:team).should be_a_new(Team)
    end
  end

  describe "GET edit" do
    login_admin
    it "assigns the requested team as @team" do
      team = Team.create! valid_attributes
      get :edit, {:id => team.to_param}
      assigns(:team).should eq(team)
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes}
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes}
        assigns(:team).should be_a(Team)
        assigns(:team).should be_persisted
      end

      it "redirects to the created team" do
        post :create, {:team => valid_attributes}
        response.should redirect_to(Team.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => {}}
        assigns(:team).should be_a_new(Team)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin
    describe "with valid params" do
      it "updates the requested team" do
        team = Team.create! valid_attributes
        # Assuming there are no other teams in the database, this
        # specifies that the Team created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Team.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => team.to_param, :team => {'these' => 'params'}}
      end

      it "assigns the requested team as @team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => valid_attributes}
        assigns(:team).should eq(team)
      end

      it "redirects to the team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => valid_attributes}
        response.should redirect_to(team)
      end
    end

    describe "with invalid params" do
      it "assigns the team as @team" do
        team = Team.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        put :update, {:id => team.to_param, :team => {}}
        assigns(:team).should eq(team)
      end

      it "re-renders the 'edit' template" do
        team = Team.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        put :update, {:id => team.to_param, :team => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested team" do
      team = Team.create! valid_attributes
      expect {
        delete :destroy, {:id => team.to_param}
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = Team.create! valid_attributes
      delete :destroy, {:id => team.to_param}
      response.should redirect_to(teams_url)
    end
  end

end
