require 'spec_helper'

describe "WatchSites" do
  
  before do
    mock_geocoding!
    @watch_site = FactoryGirl.create(:watch_site)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get watch_sites_path
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
      visit watch_sites_path
    end
    
    describe "visiting the watch site index" do
      it "should show a watch site" do
        page.should have_content(@watch_site.name)
      end
    end
    
  end
end
