require 'spec_helper'

describe "Sports" do
  
  before do
    @sport = FactoryGirl.create(:sport)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get sports_path
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
      visit sports_path
    end
    
    describe "visiting the sports index" do
      it "should show a sport" do
        page.should have_content(@sport.name)
      end
    end
    
  end
end
