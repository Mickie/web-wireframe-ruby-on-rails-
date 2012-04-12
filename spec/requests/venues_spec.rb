require 'spec_helper'

describe "Venues" do
  
  before do
    mock_geocoding!
    @venue = FactoryGirl.create(:venue)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get venues_path
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
      visit venues_path
    end
    
    describe "visiting the teams index" do
      it "should show a team" do
        page.should have_content(@venue.name)
      end
    end
    
  end
end
