require 'spec_helper'

describe EventsController do
  
  before do
    mock_geocoding!

    @home_team = FactoryGirl.create(:team, conference: FactoryGirl.create(:conference))
    @visiting_team = FactoryGirl.create(:team)
    @location = FactoryGirl.build(:location)
    
  end

  def valid_attributes
    { 
      name:'Superbowl', 
      home_team_id:@home_team.id, 
      visiting_team_id:@visiting_team.id, 
      location_attributes: accessible_attributes(Location, @location),
      event_date: Date.today,
      event_time: Time.now
    }
  end
  
  describe "GET index" do
    login_user
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, {}
      assigns(:events).should eq([event])
    end
  end

  describe "GET show" do
    login_user
    
    describe "populated events" do 
      before do
        @event = Event.create! valid_attributes
        get :show, {:id => @event.to_param}
      end
      
      it "assigns the requested event as @event" do
        assigns(:event).should eq(@event)
      end
      
      it "assigns current_user to @current_user" do
        assigns(:current_user).should eq(subject.current_user)
      end
      
      it "assigns the team hash tags to @visitingHashTag & @homeHashTag" do
        assigns(:homeHashTags).should eq( @home_team.social_info.hash_tags.split(" ") )
        assigns(:visitingHashTags).should eq( @visiting_team.social_info.hash_tags.split(" ") )
      end
    end
    
    describe "sparse events" do

      it "assigns available team hash tags" do
        @home_team.social_info = nil;
        @home_team.save
        @event = Event.create! valid_attributes
        get :show, {:id => @event.to_param}
        assigns(:visitingHashTags).should eq( @visiting_team.social_info.hash_tags.split(" ") )
        assigns(:homeHashTags).should eq( ["#" + @home_team.conference.name ]  )
      end

      it "assigns team sport to @hashTag when teams don't have one" do
        @visiting_team.social_info = nil
        @visiting_team.save
        @home_team.social_info = nil;
        @home_team.conference = nil;
        @home_team.save
        @event = Event.create! valid_attributes
        get :show, {:id => @event.to_param}
        assigns(:visitingHashTags).should eq( ["#fanzo_" + @visiting_team.sport.name] )
        assigns(:homeHashTags).should eq( ["#fanzo_" + @home_team.sport.name ]  )
      end

    end
    
    describe "events with local watch sites" do
      before do
        @event = Event.create! valid_attributes
        @theFirstWatchSite = FactoryGirl.build(:watch_site, team:@home_team)
        @theSecondWatchSite = FactoryGirl.build(:watch_site, team:@visiting_team)
        @theThirdWatchSite = FactoryGirl.build(:watch_site)
        
        WatchSite.should_receive(:near).and_return([@theFirstWatchSite, @theSecondWatchSite, @theThirdWatchSite])
      end
      
      it "returns the home teams watch sites near location in @localHomeTeamWatchSites" do
        get :show, {:id => @event.to_param}
        assigns(:localHomeTeamWatchSites).should eq([@theFirstWatchSite])
      end
      
      it "returns the visiting teams watch sites near location in @localVisitingTeamWatchSites" do
        get :show, {:id => @event.to_param}
        assigns(:localVisitingTeamWatchSites).should eq([@theSecondWatchSite])
      end
      
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new event as @event" do
      get :new, {}
      assigns(:event).should be_a_new(Event)
    end
  end

  describe "GET edit" do
    login_admin
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :edit, {:id => event.to_param}
      assigns(:event).should eq(event)
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, {:event => valid_attributes}
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, {:event => valid_attributes}
        assigns(:event).should be_a(Event)
        assigns(:event).should be_persisted
      end

      it "redirects to the created event" do
        post :create, {:event => valid_attributes}
        response.should redirect_to(Event.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        # Trigger the behavior that occurs when invalid params are submitted
        Event.any_instance.stub(:save).and_return(false)
        post :create, {:event => {}}
        assigns(:event).should be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Event.any_instance.stub(:save).and_return(false)
        post :create, {:event => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin
    describe "with valid params" do
      it "updates the requested event" do
        event = Event.create! valid_attributes
        # Assuming there are no other events in the database, this
        # specifies that the Event created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Event.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => event.to_param, :event => {'these' => 'params'}}
      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes}
        assigns(:event).should eq(event)
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes}
        response.should redirect_to(event)
      end
    end

    describe "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Event.any_instance.stub(:save).and_return(false)
        put :update, {:id => event.to_param, :event => {}}
        assigns(:event).should eq(event)
      end

      it "re-renders the 'edit' template" do
        event = Event.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Event.any_instance.stub(:save).and_return(false)
        put :update, {:id => event.to_param, :event => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, {:id => event.to_param}
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete :destroy, {:id => event.to_param}
      response.should redirect_to(events_url)
    end
  end

end
