require 'spec_helper'

describe "Leagues" do
  
  before do
    @league = FactoryGirl.create(:league)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get leagues_path
      response.should redirect_to(new_admin_session_path)
    end
  end

  describe "with admin logged in" do
    before do
      theAdmin = FactoryGirl.create(:admin)
      visit new_admin_session_path
      fill_in "Email",    with: theAdmin.email
      fill_in "Password", with: theAdmin.password
      click_button "commit"
      visit leagues_path
    end
    
    describe "visiting the leagues index" do
      it "should show a league" do
        page.should have_content(@league.name)
      end
    end
    
  end
end
