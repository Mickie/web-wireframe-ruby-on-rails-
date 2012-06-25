require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/tailgates/1/posts/1/comments").should route_to("comments#index", tailgate_id:"1", post_id:"1")
    end

    it "routes to #new" do
      get("/tailgates/1/posts/1/comments/new").should route_to("comments#new", tailgate_id:"1", post_id:"1")
    end

    it "routes to #show" do
      get("/tailgates/1/posts/1/comments/1").should route_to("comments#show", tailgate_id:"1", post_id:"1", id:"1")
    end

    it "routes to #edit" do
      get("/tailgates/1/posts/1/comments/1/edit").should route_to("comments#edit", tailgate_id:"1", post_id:"1", id:"1")
    end

    it "routes to #create" do
      post("/tailgates/1/posts/1/comments").should route_to("comments#create", tailgate_id:"1", post_id:"1")
    end

    it "routes to #update" do
      put("/tailgates/1/posts/1/comments/1").should route_to("comments#update", tailgate_id:"1", post_id:"1", id:"1")
    end

    it "routes to #destroy" do
      delete("/tailgates/1/posts/1/comments/1").should route_to("comments#destroy", tailgate_id:"1", post_id:"1", id:"1")
    end

  end
end
