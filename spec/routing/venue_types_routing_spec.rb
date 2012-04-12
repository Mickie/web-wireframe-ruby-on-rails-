require "spec_helper"

describe VenueTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/venue_types").should route_to("venue_types#index")
    end

    it "routes to #new" do
      get("/venue_types/new").should route_to("venue_types#new")
    end

    it "routes to #show" do
      get("/venue_types/1").should route_to("venue_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/venue_types/1/edit").should route_to("venue_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/venue_types").should route_to("venue_types#create")
    end

    it "routes to #update" do
      put("/venue_types/1").should route_to("venue_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/venue_types/1").should route_to("venue_types#destroy", :id => "1")
    end

  end
end
