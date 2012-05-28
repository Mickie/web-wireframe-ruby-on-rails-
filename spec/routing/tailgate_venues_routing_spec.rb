require "spec_helper"

describe TailgateVenuesController do
  describe "routing" do

    it "routes to #index" do
      get("/tailgate_venues").should route_to("tailgate_venues#index")
    end

    it "routes to #new" do
      get("/tailgate_venues/new").should route_to("tailgate_venues#new")
    end

    it "routes to #show" do
      get("/tailgate_venues/1").should route_to("tailgate_venues#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tailgate_venues/1/edit").should route_to("tailgate_venues#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tailgate_venues").should route_to("tailgate_venues#create")
    end

    it "routes to #update" do
      put("/tailgate_venues/1").should route_to("tailgate_venues#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tailgate_venues/1").should route_to("tailgate_venues#destroy", :id => "1")
    end

  end
end
