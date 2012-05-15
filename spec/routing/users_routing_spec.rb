require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #show" do
      get("/users/1").should route_to("users#show", :id => "1")
    end
    
    it "routes to #connect_twitter" do
      get("/users/1/connect_twitter").should route_to("users#connect_twitter", id: "1")
    end

    it "routes to #connect_instagram" do
      get("/users/1/connect_instagram").should route_to("users#connect_instagram", id: "1")
    end

  end
end
