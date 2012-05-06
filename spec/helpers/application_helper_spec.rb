require "spec_helper"

describe ApplicationHelper do
  describe "#logoPath" do
    it "returns the correct path" do
      helper.logoPath("test-slug", :small).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_s.gif")
      helper.logoPath("test-slug", :medium).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_m.gif")
      helper.logoPath("test-slug", :large).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_l.gif")
    end
  end
end