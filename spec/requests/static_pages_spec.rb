require 'spec_helper'

describe "StaticPages" do
  
  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    
    it "should successfully respond to a request" do
      get root_path
      response.status.should be(200)
    end
    
    it { should have_selector('title', text: 'FANZO - Uniting people around the world through sports') }
    it { should have_selector('h1', text: 'Welcome') }
    
    describe "for new users" do
      
      it { should have_link("Get Started", href: new_user_registration_path ) }
      
    end
    
  end
end
