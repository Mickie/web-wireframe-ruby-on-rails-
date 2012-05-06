require 'spec_helper'

describe "Events" do
  
  before do
    mock_geocoding!
    @event = FactoryGirl.create(:event)
  end
  
  describe "without admin or user logged in" do
    it "should redirect edit event to admin login" do
      get edit_event_path(@event)
      response.should redirect_to(new_admin_session_path)
    end

    it "should redirect new event to admin login" do
      get new_event_path
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect update event to admin login" do
      put event_path(@event)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect delete event to admin login" do
      delete event_path(@event)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect event index to user login" do
      get events_path
      response.should redirect_to(new_user_session_path)
    end
    
    it "should redirect show page to user login" do
      get event_path(@event)
      response.should redirect_to(new_user_session_path)
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
    
    describe "visiting the events index" do
      before do
        visit events_path
      end

      it "should show a event" do
        page.should have_content(@event.home_team.name)
        page.should have_content(@event.visiting_team.name)
      end
    end
    
    describe "visiting the event show page" do
      before do
        visit event_path(@event)
      end

      it "should show event data" do
        page.should have_content(@event.home_team.name)
        page.should have_content(@event.visiting_team.name)
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
    
    describe "visiting the edit event path" do
      before do
        visit edit_event_path(@event) 
      end
      it "should allow changing a event" do
        page.should have_selector("#event_name")
      end
    end
    
    describe "visiting the new event path" do
      before do
        visit new_event_path
      end
      
      it "should allow creating an event" do
        page.should have_selector("#event_name")
      end
    end
    
    
  end
end
