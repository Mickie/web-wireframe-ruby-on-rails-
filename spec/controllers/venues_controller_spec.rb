require 'spec_helper'

describe VenuesController do
  
  before do
    mock_geocoding!
    @theVenueType = FactoryGirl.create(:venue_type)
    @theLocation = FactoryGirl.create(:location)
  end
  
  
  def valid_attributes
    { name:"Pumphouse", venue_type_id:@theVenueType.id, location_id:@theLocation.id }
  end

  describe "GET index" do
    login_admin

    it "should have current_admin" do
      subject.current_admin.should_not be_nil
    end

    it "assigns all venues as @venues" do
      venue = Venue.create! valid_attributes
      get :index, {}
      assigns(:venues).should eq([venue])
    end
  end

  describe "GET show" do
    login_user
    
    it "assigns the requested venue as @venue" do
      venue = Venue.create! valid_attributes
      venue.foursquare_id = '12345'
      venue.save
      get :show, {:id => venue.to_param}
      assigns(:venue).should eq(venue)
    end
  end

  describe "GET new" do
    login_admin
    it "assigns a new venue as @venue" do
      get :new, {}
      assigns(:venue).should be_a_new(Venue)
    end
  end

  describe "GET edit" do
    login_admin
    it "assigns the requested venue as @venue" do
      venue = Venue.create! valid_attributes
      get :edit, {:id => venue.to_param}
      assigns(:venue).should eq(venue)
    end
  end

  describe "POST create" do
    login_admin
    describe "with valid params" do
      it "creates a new Venue" do
        expect {
          post :create, {:venue => valid_attributes}
        }.to change(Venue, :count).by(1)
      end

      it "assigns a newly created venue as @venue" do
        post :create, {:venue => valid_attributes}
        assigns(:venue).should be_a(Venue)
        assigns(:venue).should be_persisted
      end

      it "redirects to the created venue" do
        post :create, {:venue => valid_attributes}
        response.should redirect_to(Venue.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved venue as @venue" do
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        post :create, {:venue => {}}
        assigns(:venue).should be_a_new(Venue)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        post :create, {:venue => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin
    describe "with valid params" do
      it "updates the requested venue" do
        venue = Venue.create! valid_attributes
        # Assuming there are no other venues in the database, this
        # specifies that the Venue created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Venue.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => venue.to_param, :venue => {'these' => 'params'}}
      end

      it "assigns the requested venue as @venue" do
        venue = Venue.create! valid_attributes
        put :update, {:id => venue.to_param, :venue => valid_attributes}
        assigns(:venue).should eq(venue)
      end

      it "redirects to the venue" do
        venue = Venue.create! valid_attributes
        put :update, {:id => venue.to_param, :venue => valid_attributes}
        response.should redirect_to(venue)
      end
    end

    describe "with invalid params" do
      it "assigns the venue as @venue" do
        venue = Venue.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        put :update, {:id => venue.to_param, :venue => {}}
        assigns(:venue).should eq(venue)
      end

      it "re-renders the 'edit' template" do
        venue = Venue.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Venue.any_instance.stub(:save).and_return(false)
        put :update, {:id => venue.to_param, :venue => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested venue" do
      venue = Venue.create! valid_attributes
      expect {
        delete :destroy, {:id => venue.to_param}
      }.to change(Venue, :count).by(-1)
    end

    it "redirects to the venues list" do
      venue = Venue.create! valid_attributes
      delete :destroy, {:id => venue.to_param}
      response.should redirect_to(venues_url)
    end
  end

  describe "get_foursquare_id" do
    login_user
    before do
      @venue = FactoryGirl.create(:venue)
      @theStubClient = double(Foursquare2::Client)
      Foursquare2::Client.stub(:new).and_return(@theStubClient)
    end
    
    it "should return existing id" do
      @venue.foursquare_id = '12345'
      subject.getFoursquareId(@venue).should eq('12345')
    end
    
    it "should request id, save locally, and return if no existing id" do
      theVenuesResponse = 
      {
        venues: [
          Hashie::Mash.new(
            {
              id: "12345",
              name: "Eat At Joes"
            }),
          Hashie::Mash.new(
            {
              id: "12345",
              name: "Eat At Joes",
              location: {
                address: "Joes Street",
                postalCode: "48084"
              }
            }),
          Hashie::Mash.new(
            {
              id: "4af34dacf964a52073ec21e3",
              name: @venue.name,
              contact: {
                phone: "2484353044",
                formattedPhone: "(248) 435-3044",
                twitter: "Bailey'sPubTroy"
              },
              location: {
                address: "1965 W Maple Rd",
                crossStreet: "btwn Crooks Rd & Coolidge Hwy",
                lat: 42.54616442270757,
                lng: -83.17209362983704,
                distance: 186,
                postalCode: "48084",
                city: "Troy",
                state: "MI",
                country: "United States"
                },
              categories: [
                {
                  id: "4bf58dd8d48988d11d941735",
                  name: "Sports Bar",
                  pluralName: "Sports Bars",
                  shortName: "Sports Bar",
                  icon: {
                    prefix: "https://foursquare.com/img/categories_v2/nightlife/sportsbar_",
                    suffix: ".png"
                  },
                  primary: true
                }
              ],
              verified: true,
              stats: {
                checkinsCount: 2734,
                usersCount: 1097,
                tipCount: 35
              },
              url: "http://www.foxandhound.com/restaurantinfo.aspx?location=troy",
              likes: {
                count: 0,
                groups: [ ]
              },
              specials: {
                count: 2,
                items: [
                  {
                    id: "4f9add2c4fc6168ea76ec437",
                    type: "frequency",
                    message: "Every 5th check in, receive $5 off your total food bill.",
                    imageUrls: {
                      count: 0
                    },
                    description: "Unlocked every 5 check-ins",
                    finePrint: "Please show this to your server to receive your discount.  Discount applies to food only.",
                    icon: "frequency",
                    title: "Loyalty Special",
                    provider: "foursquare",
                    redemption: "standard",
                    likes: {
                      count: 0,
                      groups: [ ]
                    }
                  },
                  {
                    id: "4f9adc934fc6168ea76eaa17",
                    type: "count",
                    message: "Newbie Special.  On your first check in, receive a free order of chips & salsa.",
                    imageUrls: {
                      count: 0
                    },
                    description: "Unlocked on your 1st check-in",
                    finePrint: "Please show this to your server to receive your discount.",
                    icon: "newbie",
                    title: "Newbie Special",
                    provider: "foursquare",
                    redemption: "standard",
                    likes: {
                      count: 0,
                      groups: [ ]
                    }
                  }
                ]
              },
              hereNow: {
                count: 2,
                groups: [
                  {
                    type: "others",
                    name: "Other people here",
                    count: 2,
                    items: [ ]
                  }
                ]
              }
            })
          ]     
          }      
      
      @theStubClient.should_receive(:search_venues).with(ll:"#{@venue.location.latitude},#{@venue.location.longitude}",
                                                         query: @venue.name,
                                                         intent: 'match',
                                                         v:'20120609').and_return(theVenuesResponse)
      subject.getFoursquareId(@venue).should eq('4af34dacf964a52073ec21e3')
      
      theDBVenue = Venue.where(id:@venue.id).first
      theDBVenue.foursquare_id.should eq('4af34dacf964a52073ec21e3')     
    end
  end

end
