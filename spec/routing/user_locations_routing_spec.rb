require "spec_helper"

describe UserLocationsController do
  describe "routing" do

    it "routes to #create" do
      post("/users/1/user_locations").should route_to("user_locations#create", :user_id => "1")
    end

    it "routes to #destroy" do
      delete("/users/2/user_locations/1").should route_to("user_locations#destroy", :id => "1", :user_id => "2")
    end

  end
end
