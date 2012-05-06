require "spec_helper"

describe ApplicationHelper do
  describe "#logoPath" do
    it "returns the correct path for small" do
      helper.logoPath("test-slug", :small).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_s.gif")
    end

    it "returns the correct path for medium" do
      helper.logoPath("test-slug", :medium).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_m.gif")
    end

    it "returns the correct path for large" do
      helper.logoPath("test-slug", :large).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_l.gif")
    end
  end
  
  describe "#teamLogo" do
    before do
      @team = stub_model(Team, name:"Seahawks", slug:"seahawks")
    end
    
    it "returns the correct tag for small" do
      helper.teamLogo(@team, :small).should match(/.*alt="Seahawks".*height="50".*seahawks_s.gif.*width="50"/)
    end

    it "returns the correct tag for medium" do
      helper.teamLogo(@team, :medium).should match(/.*alt="Seahawks".*height="80".*seahawks_m.gif.*width="80"/)
    end

    it "returns the correct tag for large" do
      helper.teamLogo(@team, :large).should match(/.*alt="Seahawks".*height="110".*seahawks_l.gif.*width="110"/)
    end

  end
end