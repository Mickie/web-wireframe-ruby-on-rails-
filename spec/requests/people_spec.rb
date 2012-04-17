require 'spec_helper'

describe "People" do
  
  before do
    mock_geocoding!
    @person = FactoryGirl.create(:person)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get people_path
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
      visit people_path
    end
    
    describe "visiting the teams index" do
      it "should show a team" do
        page.should have_content(@person.first_name)
      end
    end
    
  end
end
