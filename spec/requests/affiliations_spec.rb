require 'spec_helper'

describe "Affiliations" do
  before do
    mock_geocoding!
    @affiliation = FactoryGirl.create(:affiliation)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get affiliations_path
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
      visit affiliations_path
    end
    
    describe "visiting the affiliations index" do
      it "should show a affiliation" do
        page.should have_content(@affiliation.name)
      end
    end
    
  end
end
