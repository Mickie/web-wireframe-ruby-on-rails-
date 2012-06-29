require 'spec_helper'

describe "QuickTweets" do
  before do
    mock_geocoding!
    @quick_tweet = FactoryGirl.create(:quick_tweet) 
  end
  
  describe "without admin or user logged in" do
    
    it "should redirect edit quick_tweet to admin login" do
      get edit_quick_tweet_path(@quick_tweet)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect new quick_tweet to admin login" do
      get new_quick_tweet_path
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect update quick_tweet to admin login" do
      put quick_tweet_path(@quick_tweet)
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should redirect delete quick_tweet to admin login" do
      delete quick_tweet_path(@quick_tweet)
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
    
    describe "visiting the quick_tweets index" do
      before do
        visit quick_tweets_path
      end

      it "should show a quick_tweet" do
        page.should have_content(@quick_tweet.name)
      end
    end
    
    describe "visiting the quick_tweet show page" do
      before do
        visit quick_tweet_path(@quick_tweet)
      end

      it "should show a quick_tweet name" do
        page.should have_content(@quick_tweet.name)
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
    
    describe "visiting the edit quick_tweet path" do
      before do
        visit edit_quick_tweet_path(@quick_tweet) 
      end
      it "should allow changing a quick_tweet" do
        page.should have_selector("#quick_tweet_name")
      end
    end
    
    describe "visiting the new quick_tweet path" do
      before do
        visit new_quick_tweet_path
      end
      
      it "should allow creating an quick_tweet" do
        page.should have_selector("#quick_tweet_name")
      end
    end    
    
  end
end
