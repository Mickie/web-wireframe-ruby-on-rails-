require 'spec_helper'

describe "GameWatches" do
  
  before do
    mock_geocoding!
    @game_watch = FactoryGirl.create(:game_watch)
  end
  
  describe "without admin login" do
    it "should redirect to admin login" do
      get game_watches_path
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
      visit game_watches_path
    end
    
    describe "visiting the game watch index" do
      it "should show a game watch" do
        page.should have_content(@game_watch.name)
      end
    end
    
  end
end
