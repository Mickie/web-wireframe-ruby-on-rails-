require 'spec_helper'

describe "Teams" do
  
  before do
    mock_geocoding!
    @team = FactoryGirl.create(:team) 
  end
  
  describe "without admin or user logged in" do
    
    it "should redirect edit team to admin login" do
      get edit_team_path(@team)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect new team to admin login" do
      get new_team_path
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect update team to admin login" do
      put team_path(@team)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect delete team to admin login" do
      delete team_path(@team)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect team index to user login" do
      get teams_path
      response.should redirect_to(new_user_session_path)
    end
    
    it "should redirect show page to user login" do
      get team_path(@team)
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
    
    describe "visiting the teams index" do
      before do
        visit teams_path
      end

      it "should show a team" do
        page.should have_content(@team.name)
      end
    end
    
    describe "visiting the team show page" do
      before do
        visit team_path(@team)
      end

      it "should show a team name" do
        page.should have_content(@team.name)
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
    
    describe "visiting the edit team path" do
      before do
        visit edit_team_path(@team) 
      end
      it "should allow changing a team" do
        page.should have_selector("#team_name")
      end
    end
    
    describe "visiting the new team path" do
      before do
        visit new_team_path
      end
      
      it "should allow creating an team" do
        page.should have_selector("#team_name")
      end
    end    
    
  end
end
