require "spec_helper"

describe FanzoTipsController do
  describe "routing" do

    it "routes to #index" do
      get("/fanzo_tips").should route_to("fanzo_tips#index")
    end

    it "routes to #new" do
      get("/fanzo_tips/new").should route_to("fanzo_tips#new")
    end

    it "routes to #show" do
      get("/fanzo_tips/1").should route_to("fanzo_tips#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fanzo_tips/1/edit").should route_to("fanzo_tips#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fanzo_tips").should route_to("fanzo_tips#create")
    end

    it "routes to #update" do
      put("/fanzo_tips/1").should route_to("fanzo_tips#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fanzo_tips/1").should route_to("fanzo_tips#destroy", :id => "1")
    end

  end
end
