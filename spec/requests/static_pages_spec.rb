require 'spec_helper'

describe "StaticPages" do
  
  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    
    it "should successfully respond to a request" do
      get root_path
      response.status.should be(200)
    end
    
    it { should have_selector('title', text: 'Fanzo - Where Fans Rule!') }
    it { should have_selector('p.tagline', text: 'where fans rule') }
    
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
