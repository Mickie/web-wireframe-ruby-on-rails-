require 'spec_helper'

describe "Divisions" do
  before do
    @division = FactoryGirl.create(:division)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get divisions_path
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
      visit divisions_path
    end
    
    describe "visiting the divisions index" do
      it "should show a division" do
        page.should have_content(@division.name)
      end
    end
    
  end
end
