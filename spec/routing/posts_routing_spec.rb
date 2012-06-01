require "spec_helper"

describe PostsController do
  describe "routing" do

    it "routes to #index" do
      get("/tailgates/1/posts").should route_to("posts#index", tailgate_id:"1")
    end

    it "routes to #new" do
      get("/tailgates/1/posts/new").should route_to("posts#new", tailgate_id:"1")
    end

    it "routes to #show" do
      get("/tailgates/2/posts/1").should route_to("posts#show", :id => "1", tailgate_id:"2")
    end

    it "routes to #edit" do
      get("/tailgates/2/posts/1/edit").should route_to("posts#edit", :id => "1", tailgate_id:"2")
    end

    it "routes to #create" do
      post("/tailgates/2/posts").should route_to("posts#create", tailgate_id:"2")
    end

    it "routes to #update" do
      put("/tailgates/2/posts/1").should route_to("posts#update", :id => "1", tailgate_id:"2")
    end

    it "routes to #destroy" do
      delete("/tailgates/2/posts/1").should route_to("posts#destroy", :id => "1", tailgate_id:"2") 
    end

  end
end
