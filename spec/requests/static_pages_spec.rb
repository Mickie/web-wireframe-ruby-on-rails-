require 'spec_helper'

describe "StaticPages" do
  
  subject { page }
  
  describe "Home page" do

    before do
      mock_geocoding!
      @team = FactoryGirl.create(:team)
      Team.stub(:find).and_return(@team)
      theTailgate = FactoryGirl.create(:tailgate, team:@team, official:true)
      visit root_path 
    end
    
    it "should successfully respond to a request" do
      get root_path
      response.status.should be(200)
    end
    
    it { should have_selector('div.tagline', text: 'where fans rule') }
    
    describe "for guest" do
      
      it { should have_link("Log in" ) }
      
    end
    
  end
  
  describe "channel html file" do
    it "should return facebook script tag only" do
      get '/channel.html'
      
      response.status.should be(200)
      response.body.should eq("<script src='//connect.facebook.net/en_US/all.js'></script>") 
    end
  end
end
