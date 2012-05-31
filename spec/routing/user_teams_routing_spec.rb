require "spec_helper"

describe UserTeamsController do
  describe "routing" do

    it "routes to #create" do
      post("/users/1/user_teams").should route_to("user_teams#create", :user_id => "1")
    end

    it "routes to #destroy" do
      delete("/users/2/user_teams/1").should route_to("user_teams#destroy", :id => "1", :user_id => "2")
    end

  end
end
