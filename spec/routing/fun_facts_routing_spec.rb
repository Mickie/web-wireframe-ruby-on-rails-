require "spec_helper"

describe FunFactsController do
  describe "routing" do

    it "routes to #index" do
      get("/fun_facts").should route_to("fun_facts#index")
    end

    it "routes to #new" do
      get("/fun_facts/new").should route_to("fun_facts#new")
    end

    it "routes to #show" do
      get("/fun_facts/1").should route_to("fun_facts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fun_facts/1/edit").should route_to("fun_facts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fun_facts").should route_to("fun_facts#create")
    end

    it "routes to #update" do
      put("/fun_facts/1").should route_to("fun_facts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fun_facts/1").should route_to("fun_facts#destroy", :id => "1")
    end

  end
end
