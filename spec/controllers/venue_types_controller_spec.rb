require 'spec_helper'

describe VenueTypesController do
  login_admin
  
  it "should have current_admin" do
    subject.current_admin.should_not be_nil
  end
  
  def valid_attributes
    { name:"Pub" }
  end

  describe "GET index" do
    it "assigns all venue_types as @venue_types" do
      venue_type = VenueType.create! valid_attributes
      get :index, {}
      assigns(:venue_types).should eq([venue_type])
    end
  end 

  describe "GET show" do
    it "assigns the requested venue_type as @venue_type" do
      venue_type = VenueType.create! valid_attributes
      get :show, {:id => venue_type.to_param}
      assigns(:venue_type).should eq(venue_type)
    end
  end

  describe "GET new" do
    it "assigns a new venue_type as @venue_type" do
      get :new, {}
      assigns(:venue_type).should be_a_new(VenueType)
    end
  end

  describe "GET edit" do
    it "assigns the requested venue_type as @venue_type" do
      venue_type = VenueType.create! valid_attributes
      get :edit, {:id => venue_type.to_param}
      assigns(:venue_type).should eq(venue_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new VenueType" do
        expect {
          post :create, {:venue_type => valid_attributes}
        }.to change(VenueType, :count).by(1)
      end

      it "assigns a newly created venue_type as @venue_type" do
        post :create, {:venue_type => valid_attributes}
        assigns(:venue_type).should be_a(VenueType)
        assigns(:venue_type).should be_persisted
      end

      it "redirects to the created venue_type" do
        post :create, {:venue_type => valid_attributes}
        response.should redirect_to(VenueType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved venue_type as @venue_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        VenueType.any_instance.stub(:save).and_return(false)
        post :create, {:venue_type => {}}
        assigns(:venue_type).should be_a_new(VenueType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        VenueType.any_instance.stub(:save).and_return(false)
        post :create, {:venue_type => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested venue_type" do
        venue_type = VenueType.create! valid_attributes
        # Assuming there are no other venue_types in the database, this
        # specifies that the VenueType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        VenueType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => venue_type.to_param, :venue_type => {'these' => 'params'}}
      end

      it "assigns the requested venue_type as @venue_type" do
        venue_type = VenueType.create! valid_attributes
        put :update, {:id => venue_type.to_param, :venue_type => valid_attributes}
        assigns(:venue_type).should eq(venue_type)
      end

      it "redirects to the venue_type" do
        venue_type = VenueType.create! valid_attributes
        put :update, {:id => venue_type.to_param, :venue_type => valid_attributes}
        response.should redirect_to(venue_type)
      end
    end

    describe "with invalid params" do
      it "assigns the venue_type as @venue_type" do
        venue_type = VenueType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        VenueType.any_instance.stub(:save).and_return(false)
        put :update, {:id => venue_type.to_param, :venue_type => {}}
        assigns(:venue_type).should eq(venue_type)
      end

      it "re-renders the 'edit' template" do
        venue_type = VenueType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        VenueType.any_instance.stub(:save).and_return(false)
        put :update, {:id => venue_type.to_param, :venue_type => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested venue_type" do
      venue_type = VenueType.create! valid_attributes
      expect {
        delete :destroy, {:id => venue_type.to_param}
      }.to change(VenueType, :count).by(-1)
    end

    it "redirects to the venue_types list" do
      venue_type = VenueType.create! valid_attributes
      delete :destroy, {:id => venue_type.to_param}
      response.should redirect_to(venue_types_url)
    end
  end

end
