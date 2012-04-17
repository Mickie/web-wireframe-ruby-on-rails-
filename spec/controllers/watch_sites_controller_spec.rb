require 'spec_helper'

describe WatchSitesController do
  #login_admin
  
  before do
    mock_geocoding!

    @team = FactoryGirl.create(:team)
    @venue = FactoryGirl.create(:venue)
  end

  def valid_attributes
    { 
      name:'Greater Seattle ND Club Watch Site', 
      team_id:@team.id, 
      venue_id:@venue.id
    }
  end

  describe "GET index" do
    it "assigns all watch_sites as @watch_sites" do
      watch_site = WatchSite.create! valid_attributes
      get :index, {}
      assigns(:watch_sites).should eq([watch_site])
    end
  end

  describe "GET show" do
    it "assigns the requested watch_site as @watch_site" do
      watch_site = WatchSite.create! valid_attributes
      get :show, {:id => watch_site.to_param}
      assigns(:watch_site).should eq(watch_site)
    end
  end

  describe "GET new" do
    it "assigns a new watch_site as @watch_site" do
      get :new, {}
      assigns(:watch_site).should be_a_new(WatchSite)
    end
  end

  describe "GET edit" do
    it "assigns the requested watch_site as @watch_site" do
      watch_site = WatchSite.create! valid_attributes
      get :edit, {:id => watch_site.to_param}
      assigns(:watch_site).should eq(watch_site)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new WatchSite" do
        expect {
          post :create, {:watch_site => valid_attributes}
        }.to change(WatchSite, :count).by(1)
      end

      it "assigns a newly created watch_site as @watch_site" do
        post :create, {:watch_site => valid_attributes}
        assigns(:watch_site).should be_a(WatchSite)
        assigns(:watch_site).should be_persisted
      end

      it "redirects to the created watch_site" do
        post :create, {:watch_site => valid_attributes}
        response.should redirect_to(WatchSite.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved watch_site as @watch_site" do
        # Trigger the behavior that occurs when invalid params are submitted
        WatchSite.any_instance.stub(:save).and_return(false)
        post :create, {:watch_site => {}}
        assigns(:watch_site).should be_a_new(WatchSite)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        WatchSite.any_instance.stub(:save).and_return(false)
        post :create, {:watch_site => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested watch_site" do
        watch_site = WatchSite.create! valid_attributes
        # Assuming there are no other watch_sites in the database, this
        # specifies that the WatchSite created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        WatchSite.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => watch_site.to_param, :watch_site => {'these' => 'params'}}
      end

      it "assigns the requested watch_site as @watch_site" do
        watch_site = WatchSite.create! valid_attributes
        put :update, {:id => watch_site.to_param, :watch_site => valid_attributes}
        assigns(:watch_site).should eq(watch_site)
      end

      it "redirects to the watch_site" do
        watch_site = WatchSite.create! valid_attributes
        put :update, {:id => watch_site.to_param, :watch_site => valid_attributes}
        response.should redirect_to(watch_site)
      end
    end

    describe "with invalid params" do
      it "assigns the watch_site as @watch_site" do
        watch_site = WatchSite.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        WatchSite.any_instance.stub(:save).and_return(false)
        put :update, {:id => watch_site.to_param, :watch_site => {}}
        assigns(:watch_site).should eq(watch_site)
      end

      it "re-renders the 'edit' template" do
        watch_site = WatchSite.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        WatchSite.any_instance.stub(:save).and_return(false)
        put :update, {:id => watch_site.to_param, :watch_site => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested watch_site" do
      watch_site = WatchSite.create! valid_attributes
      expect {
        delete :destroy, {:id => watch_site.to_param}
      }.to change(WatchSite, :count).by(-1)
    end

    it "redirects to the watch_sites list" do
      watch_site = WatchSite.create! valid_attributes
      delete :destroy, {:id => watch_site.to_param}
      response.should redirect_to(watch_sites_url)
    end
  end

end
