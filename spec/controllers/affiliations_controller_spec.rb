require 'spec_helper'

describe AffiliationsController do

  login_admin
  
  before do
    mock_geocoding!

    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
  end

  def valid_attributes
    { name:'University of Notre Dame', location_id:@location.id, social_info_id: @social_info.id }
  end
  
  describe "GET index" do
    it "assigns all affiliations as @affiliations" do
      affiliation = Affiliation.create! valid_attributes
      get :index, {}
      assigns(:affiliations).should eq([affiliation])
    end
  end

  describe "GET show" do
    it "assigns the requested affiliation as @affiliation" do
      affiliation = Affiliation.create! valid_attributes
      get :show, {:id => affiliation.to_param}
      assigns(:affiliation).should eq(affiliation)
    end
  end

  describe "GET new" do
    it "assigns a new affiliation as @affiliation" do
      get :new, {}
      assigns(:affiliation).should be_a_new(Affiliation)
    end
  end

  describe "GET edit" do
    it "assigns the requested affiliation as @affiliation" do
      affiliation = Affiliation.create! valid_attributes
      get :edit, {:id => affiliation.to_param}
      assigns(:affiliation).should eq(affiliation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Affiliation" do
        expect {
          post :create, {:affiliation => valid_attributes}
        }.to change(Affiliation, :count).by(1)
      end

      it "assigns a newly created affiliation as @affiliation" do
        post :create, {:affiliation => valid_attributes}
        assigns(:affiliation).should be_a(Affiliation)
        assigns(:affiliation).should be_persisted
      end

      it "redirects to the created affiliation" do
        post :create, {:affiliation => valid_attributes}
        response.should redirect_to(Affiliation.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved affiliation as @affiliation" do
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliation.any_instance.stub(:save).and_return(false)
        post :create, {:affiliation => {}}
        assigns(:affiliation).should be_a_new(Affiliation)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliation.any_instance.stub(:save).and_return(false)
        post :create, {:affiliation => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested affiliation" do
        affiliation = Affiliation.create! valid_attributes
        # Assuming there are no other affiliations in the database, this
        # specifies that the Affiliation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Affiliation.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => affiliation.to_param, :affiliation => {'these' => 'params'}}
      end

      it "assigns the requested affiliation as @affiliation" do
        affiliation = Affiliation.create! valid_attributes
        put :update, {:id => affiliation.to_param, :affiliation => valid_attributes}
        assigns(:affiliation).should eq(affiliation)
      end

      it "redirects to the affiliation" do
        affiliation = Affiliation.create! valid_attributes
        put :update, {:id => affiliation.to_param, :affiliation => valid_attributes}
        response.should redirect_to(affiliation)
      end
    end

    describe "with invalid params" do
      it "assigns the affiliation as @affiliation" do
        affiliation = Affiliation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliation.any_instance.stub(:save).and_return(false)
        put :update, {:id => affiliation.to_param, :affiliation => {}}
        assigns(:affiliation).should eq(affiliation)
      end

      it "re-renders the 'edit' template" do
        affiliation = Affiliation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliation.any_instance.stub(:save).and_return(false)
        put :update, {:id => affiliation.to_param, :affiliation => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested affiliation" do
      affiliation = Affiliation.create! valid_attributes
      expect {
        delete :destroy, {:id => affiliation.to_param}
      }.to change(Affiliation, :count).by(-1)
    end

    it "redirects to the affiliations list" do
      affiliation = Affiliation.create! valid_attributes
      delete :destroy, {:id => affiliation.to_param}
      response.should redirect_to(affiliations_url)
    end
  end

end
