require "spec_helper"

describe StaticPagesController do
  describe "routing" do

    it "routes to #about" do
      get("/about").should route_to("static_pages#about")
    end

    it "routes to #fanzo_team" do
      get("/fanzo_team").should route_to("static_pages#fanzo_team")
    end

    it "routes to #channel" do
      get("/channel").should route_to("static_pages#channel")
    end

  end
end
