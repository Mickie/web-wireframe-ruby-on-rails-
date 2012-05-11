require "spec_helper"

describe QuickTweetsController do
  describe "routing" do

    it "routes to #index" do
      get("/quick_tweets").should route_to("quick_tweets#index")
    end

    it "routes to #new" do
      get("/quick_tweets/new").should route_to("quick_tweets#new")
    end

    it "routes to #show" do
      get("/quick_tweets/1").should route_to("quick_tweets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/quick_tweets/1/edit").should route_to("quick_tweets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/quick_tweets").should route_to("quick_tweets#create")
    end

    it "routes to #update" do
      put("/quick_tweets/1").should route_to("quick_tweets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/quick_tweets/1").should route_to("quick_tweets#destroy", :id => "1")
    end

  end
end
