require "spec_helper"

describe BragsController do
  describe "routing" do

    it "routes to #index" do
      get("/brags").should route_to("brags#index")
    end

    it "routes to #new" do
      get("/brags/new").should route_to("brags#new")
    end

    it "routes to #show" do
      get("/brags/1").should route_to("brags#show", :id => "1")
    end

    it "routes to #edit" do
      get("/brags/1/edit").should route_to("brags#edit", :id => "1")
    end

    it "routes to #create" do
      post("/brags").should route_to("brags#create")
    end

    it "routes to #update" do
      put("/brags/1").should route_to("brags#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/brags/1").should route_to("brags#destroy", :id => "1")
    end

  end
end
