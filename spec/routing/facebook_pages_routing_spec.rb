require "spec_helper"

describe FacebookPagesController do
  describe "routing" do

    it "routes to #index" do
      get("/facebook_pages").should route_to("facebook_pages#index")
    end

    it "routes to #new" do
      get("/facebook_pages/new").should route_to("facebook_pages#new")
    end

    it "routes to #show" do
      get("/facebook_pages/1").should route_to("facebook_pages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/facebook_pages/1/edit").should route_to("facebook_pages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/facebook_pages").should route_to("facebook_pages#create")
    end

    it "routes to #update" do
      put("/facebook_pages/1").should route_to("facebook_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/facebook_pages/1").should route_to("facebook_pages#destroy", :id => "1")
    end

  end
end
