require "spec_helper"

describe TailgatesController do
  describe "routing" do

    it "routes to #index" do
      get("/tailgates").should route_to("tailgates#index")
    end

    it "routes to #new" do
      get("/tailgates/new").should route_to("tailgates#new")
    end

    it "routes to #show" do
      get("/tailgates/1").should route_to("tailgates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tailgates/1/edit").should route_to("tailgates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tailgates").should route_to("tailgates#create")
    end

    it "routes to #update" do
      put("/tailgates/1").should route_to("tailgates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tailgates/1").should route_to("tailgates#destroy", :id => "1")
    end

  end
end
