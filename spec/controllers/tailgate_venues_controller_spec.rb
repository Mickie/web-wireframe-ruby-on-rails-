require 'spec_helper'

describe TailgateVenuesController do

  before do
    mock_geocoding!

    @tailgate = FactoryGirl.create(:tailgate)
    @venue = FactoryGirl.create(:venue)
  end

  def valid_attributes
    { 
      tailgate_id:@tailgate.id,
      venue_id:@venue.id 
    }
  end


  describe "GET index" do
    it "assigns all tailgate_venues as @tailgate_venues" do
      tailgate_venue = TailgateVenue.create! valid_attributes
      get :index, {}
      assigns(:tailgate_venues).should eq([tailgate_venue])
    end
  end

  describe "GET show" do
    it "assigns the requested tailgate_venue as @tailgate_venue" do
      tailgate_venue = TailgateVenue.create! valid_attributes
      get :show, {:id => tailgate_venue.to_param}
      assigns(:tailgate_venue).should eq(tailgate_venue)
    end
  end

  describe "GET new" do
    it "assigns a new tailgate_venue as @tailgate_venue" do
      get :new, {}
      assigns(:tailgate_venue).should be_a_new(TailgateVenue)
    end
  end

  describe "GET edit" do
    it "assigns the requested tailgate_venue as @tailgate_venue" do
      tailgate_venue = TailgateVenue.create! valid_attributes
      get :edit, {:id => tailgate_venue.to_param}
      assigns(:tailgate_venue).should eq(tailgate_venue)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TailgateVenue" do
        expect {
          post :create, {:tailgate_venue => valid_attributes}
        }.to change(TailgateVenue, :count).by(1)
      end

      it "assigns a newly created tailgate_venue as @tailgate_venue" do
        post :create, {:tailgate_venue => valid_attributes}
        assigns(:tailgate_venue).should be_a(TailgateVenue)
        assigns(:tailgate_venue).should be_persisted
      end

      it "redirects to the created tailgate_venue" do
        post :create, {:tailgate_venue => valid_attributes}
        response.should redirect_to(TailgateVenue.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tailgate_venue as @tailgate_venue" do
        # Trigger the behavior that occurs when invalid params are submitted
        TailgateVenue.any_instance.stub(:save).and_return(false)
        post :create, {:tailgate_venue => {}}
        assigns(:tailgate_venue).should be_a_new(TailgateVenue)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TailgateVenue.any_instance.stub(:save).and_return(false)
        post :create, {:tailgate_venue => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tailgate_venue" do
        tailgate_venue = TailgateVenue.create! valid_attributes
        # Assuming there are no other tailgate_venues in the database, this
        # specifies that the TailgateVenue created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TailgateVenue.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => tailgate_venue.to_param, :tailgate_venue => {'these' => 'params'}}
      end

      it "assigns the requested tailgate_venue as @tailgate_venue" do
        tailgate_venue = TailgateVenue.create! valid_attributes
        put :update, {:id => tailgate_venue.to_param, :tailgate_venue => valid_attributes}
        assigns(:tailgate_venue).should eq(tailgate_venue)
      end

      it "redirects to the tailgate_venue" do
        tailgate_venue = TailgateVenue.create! valid_attributes
        put :update, {:id => tailgate_venue.to_param, :tailgate_venue => valid_attributes}
        response.should redirect_to(tailgate_venue)
      end
    end

    describe "with invalid params" do
      it "assigns the tailgate_venue as @tailgate_venue" do
        tailgate_venue = TailgateVenue.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TailgateVenue.any_instance.stub(:save).and_return(false)
        put :update, {:id => tailgate_venue.to_param, :tailgate_venue => {}}
        assigns(:tailgate_venue).should eq(tailgate_venue)
      end

      it "re-renders the 'edit' template" do
        tailgate_venue = TailgateVenue.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TailgateVenue.any_instance.stub(:save).and_return(false)
        put :update, {:id => tailgate_venue.to_param, :tailgate_venue => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tailgate_venue" do
      tailgate_venue = TailgateVenue.create! valid_attributes
      expect {
        delete :destroy, {:id => tailgate_venue.to_param}
      }.to change(TailgateVenue, :count).by(-1)
    end

    it "redirects to the tailgate_venues list" do
      tailgate_venue = TailgateVenue.create! valid_attributes
      delete :destroy, {:id => tailgate_venue.to_param}
      response.should redirect_to(tailgate_venues_url)
    end
  end

end
