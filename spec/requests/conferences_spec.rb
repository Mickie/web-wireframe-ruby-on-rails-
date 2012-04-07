require 'spec_helper'

describe "Conferences" do
  before do
    @conference = FactoryGirl.create(:conference)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get conferences_path
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
      visit conferences_path
    end
    
    describe "visiting the conferences index" do
      it "should show a conference" do
        page.should have_content(@conference.name)
      end
    end
    
  end
end
