require "spec_helper"

describe WatchSitesController do
  describe "routing" do

    it "routes to #index" do
      get("/watch_sites").should route_to("watch_sites#index")
    end

    it "routes to #new" do
      get("/watch_sites/new").should route_to("watch_sites#new")
    end

    it "routes to #show" do
      get("/watch_sites/1").should route_to("watch_sites#show", :id => "1")
    end

    it "routes to #edit" do
      get("/watch_sites/1/edit").should route_to("watch_sites#edit", :id => "1")
    end

    it "routes to #create" do
      post("/watch_sites").should route_to("watch_sites#create")
    end

    it "routes to #update" do
      put("/watch_sites/1").should route_to("watch_sites#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/watch_sites/1").should route_to("watch_sites#destroy", :id => "1")
    end

  end
end
