require "spec_helper"

describe EventPostsController do
  describe "routing" do

    it "routes to #index" do
      get("/events/1/event_posts").should route_to("event_posts#index", event_id:"1")
    end

    it "routes to #new" do
      get("/events/1/event_posts/new").should route_to("event_posts#new", event_id:"1")
    end

    it "routes to #show" do
      get("/events/2/event_posts/1").should route_to("event_posts#show", :id => "1", event_id:"2")
    end

    it "routes to #edit" do
      get("/events/2/event_posts/1/edit").should route_to("event_posts#edit", :id => "1", event_id:"2")
    end

    it "routes to #create" do
      post("/events/2/event_posts").should route_to("event_posts#create", event_id:"2")
    end

    it "routes to #update" do
      put("/events/2/event_posts/1").should route_to("event_posts#update", :id => "1", event_id:"2")
    end

    it "routes to #destroy" do
      delete("/events/2/event_posts/1").should route_to("event_posts#destroy", :id => "1", event_id:"2")
    end

  end
end
