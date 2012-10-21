require "spec_helper"

describe ApplicationHelper do
  describe "#logoPath" do
    it "returns the correct path for small" do
      helper.logoPath("test-slug", :small).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_l.png")
    end

    it "returns the correct path for medium" do
      helper.logoPath("test-slug", :medium).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_l.png")
    end

    it "returns the correct path for large" do
      helper.logoPath("test-slug", :large).should eql("http://localhost/~paulingalls/fanzo_site/static/logos/test-slug_l.png")
    end
  end
  
  describe "#teamLogo" do
    before do
      @team = stub_model(Team, name:"Seahawks", slug:"seahawks")
    end
    
    it "returns the correct tag for small" do
      helper.teamLogo(@team, :small).should match(/.*alt="Seahawks".*height="50".*seahawks_l.png.*width="50"/)
    end

    it "returns the correct tag for medium" do
      helper.teamLogo(@team, :medium).should match(/.*alt="Seahawks".*height="80".*seahawks_l.png.*width="80"/)
    end

    it "returns the correct tag for large" do
      helper.teamLogo(@team, :large).should match(/.*alt="Seahawks".*height="110".*seahawks_l.png.*width="110"/)
    end

  end
  
  describe "#getTailgateBitly" do
    let(:tailgate) { 
      mock_geocoding! 
      FactoryGirl.create( :tailgate ) 
    }
    
    it "should return cached value" do
      tailgate.bitly = "http://bitly"
      helper.getTailgateBitly(tailgate).should eq(tailgate.bitly)
    end
    
    it "should call bitly to get value if not cached, then cache it" do
      theStubClient = double(Bitly::V3::Client)
      Bitly.stub(:new).and_return(theStubClient)
      theResponse = double(Bitly::V3::Url)
      theResponse.stub(:short_url).and_return("http://bit.ly/foo")
      
      theStubClient.should_receive(:shorten).and_return(theResponse)
      helper.getTailgateBitly(tailgate).should eq("http://bit.ly/foo")
      tailgate.bitly.should eq("http://bit.ly/foo") 
    end 
  end

  describe "#getLargeLogoBitly" do
    let(:team) {
      mock_geocoding! 
      FactoryGirl.create(:team) 
    }
    
    it "should return cached value" do
      team.large_logo_bitly = "http://bitly"
      helper.getLargeLogoBitly(team).should eq(team.large_logo_bitly)
    end
    
    it "should call bitly to get value if not cached, then cache it" do
      theStubClient = double(Bitly::V3::Client)
      Bitly.stub(:new).and_return(theStubClient)
      theResponse = double(Bitly::V3::Url)
      theResponse.stub(:short_url).and_return("http://bit.ly/foo")
      
      theStubClient.should_receive(:shorten).and_return(theResponse)
      helper.getLargeLogoBitly(team).should eq("http://bit.ly/foo")
      team.large_logo_bitly.should eq("http://bit.ly/foo") 
    end 
  end
  
  
end