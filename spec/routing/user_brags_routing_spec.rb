require "spec_helper"

describe UserBragsController do
  describe "routing" do

    it "routes to #create" do
      post("/users/1/user_brags").should route_to("user_brags#create", user_id: "1")
    end

    it "routes to #destroy" do
      delete("/users/2/user_brags/1").should route_to("user_brags#destroy", id: "1", user_id: "2")
    end

  end
end
