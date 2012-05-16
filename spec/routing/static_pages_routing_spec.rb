require "spec_helper"

describe StaticPagesController do
  describe "routing" do

    it "routes to #about" do
      get("/about").should route_to("static_pages#about")
    end

    it "routes to #contact" do
      get("/contact").should route_to("static_pages#contact")
    end

    it "routes to #channel" do
      get("/channel").should route_to("static_pages#channel")
    end

  end
end
