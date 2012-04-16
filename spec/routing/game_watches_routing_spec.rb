require "spec_helper"

describe GameWatchesController do
  describe "routing" do

    it "routes to #index" do
      get("/game_watches").should route_to("game_watches#index")
    end

    it "routes to #new" do
      get("/game_watches/new").should route_to("game_watches#new")
    end

    it "routes to #show" do
      get("/game_watches/1").should route_to("game_watches#show", :id => "1")
    end

    it "routes to #edit" do
      get("/game_watches/1/edit").should route_to("game_watches#edit", :id => "1")
    end

    it "routes to #create" do
      post("/game_watches").should route_to("game_watches#create")
    end

    it "routes to #update" do
      put("/game_watches/1").should route_to("game_watches#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/game_watches/1").should route_to("game_watches#destroy", :id => "1")
    end

  end
end
