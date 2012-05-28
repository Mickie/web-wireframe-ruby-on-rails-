require 'spec_helper'

describe "TailgateVenues" do

  before do
    mock_geocoding!
    @tailgateVenue = TailgateVenue.create tailgate:FactoryGirl.create(:tailgate), venue:FactoryGirl.create(:venue)
  end
  
  describe "without admin or user logged in" do
    
    it "should redirect edit team to admin login" do
      get edit_tailgate_venue_path(@tailgateVenue)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect new tailgate_venue to admin login" do
      get new_tailgate_venue_path
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect update tailgate_venue to admin login" do
      put tailgate_venue_path(@tailgateVenue)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect delete tailgate_venue to user login" do
      delete tailgate_venue_path(@tailgateVenue)
      response.should redirect_to(new_user_session_path)
    end
    
    it "should redirect tailgate_venue index to user login" do
      get tailgate_venues_path
      response.should redirect_to(new_user_session_path)
    end
    
    it "should redirect show page to admin login" do
      get tailgate_venue_path(@tailgateVenue)
      response.should redirect_to(new_admin_session_path)
    end

  end

  describe "with user logged in" do
    before do
      theUser = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in "Email",    with: theUser.email
      fill_in "Password", with: theUser.password
      click_button "commit"
    end
    
    describe "visiting the tailgate_venue index" do
      before do
        visit tailgate_venues_path
      end

      it "should show a tailgate" do
        page.should have_content(@tailgateVenue.tailgate.name)
      end

      it "should show a venue" do
        page.should have_content(@tailgateVenue.venue.name)
      end
    end
    
  end

  describe "with admin logged in" do
    before do
      theAdmin = FactoryGirl.create(:admin)
      visit new_admin_session_path
      fill_in "Email",    with: theAdmin.email
      fill_in "Password", with: theAdmin.password
      click_button "commit"
    end
    
    describe "visiting the edit tailgate_venue path" do
      before do
        visit edit_tailgate_venue_path(@tailgateVenue) 
      end
      it "should allow changing a team" do
        page.should have_selector("#tailgate_venue_tailgate_id")
      end
    end
    
    describe "visiting the new tailgate_venue path" do
      before do
        visit new_tailgate_venue_path
      end
      
      it "should allow creating a tailgate venue" do
        page.should have_selector("#tailgate_venue_tailgate_id")
      end
    end    
    
    describe "visiting the tailgate_venue show page" do
      before do
        visit tailgate_venue_path(@tailgateVenue)
      end

      it "should show a tailgate name" do
        page.should have_content(@tailgateVenue.tailgate.name)
      end

      it "should show a venue name" do
        page.should have_content(@tailgateVenue.venue.name)
      end
    end
  end

end
