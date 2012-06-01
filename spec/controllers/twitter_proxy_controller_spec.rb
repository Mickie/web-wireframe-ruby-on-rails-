require 'spec_helper'

describe TwitterProxyController do
  
  describe "before filters" do
    
    describe "without user logged in" do
      it "redirects to user page" do
        post 'update_status', statusText: "test status"
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "with user logged in" do
      login_user
  
      describe "when user not connected to twitter" do
        it "should redirect to the new connection page" do
          post 'update_status', statusText: "test status", format: :json
          response.should redirect_to("/users/auth/twitter")
        end
      end
    end
  end
  
  describe "With twitter connected logged in user" do
    login_user
    before do
      subject.current_user.twitter_user_token = "token"
      subject.current_user.twitter_user_secret = "secret"
    end

    describe "POST 'update_status'" do
      describe "responds to JSON request" do
        before do
          theStatus = double("Twitter::Status")
          theStatus.stub(:to_json).and_return({ text:'test status' }.to_json)
          theClient = double("Twitter::Client")
          theClient.should_receive(:update).with("test status").and_return(theStatus)
          Twitter::Client.stub(:new).and_return(theClient)
          post 'update_status', statusText: "test status", format: :json
        end
  
        it "returns http success" do
          response.should be_success
        end
        
        it "and returns valid JSON" do
          theResult = JSON.parse(response.body)
          theResult['text'].should eq("test status");
        end
      end
      
      describe "handles replys" do
        before do
          theStatus = double("Twitter::Status")
          theStatus.stub(:to_json).and_return({ text:'test status' }.to_json)
          theClient = double("Twitter::Client")
          theClient.should_receive(:update).with("test status", {in_reply_to_status_id:1}).and_return(theStatus)
          Twitter::Client.stub(:new).and_return(theClient)
          post 'update_status', statusText: "test status", replyId: 1, format: :json
        end
        
        it "and returns valid JSON" do
          theResult = JSON.parse(response.body)
          theResult['text'].should eq("test status");
        end
      end
    end
  
    describe "POST 'retweet'" do
      describe "responds to JSON request" do
        before do
          theStatus = double("Twitter::Status")
          theStatus.stub(:to_json).and_return({ text:'test status', retweetId: 'foo' }.to_json)
          theClient = double("Twitter::Client")
          theClient.should_receive(:retweet).with(1).and_return(theStatus)
          Twitter::Client.stub(:new).and_return(theClient)
          post 'retweet', tweetId: 1, format: :json
        end
        
        it "returns http success" do
          response.should be_success
        end

        it "and returns valid JSON" do
          theResult = JSON.parse(response.body)
          theResult['text'].should eq("test status");
        end
      end
    end
  
    describe "POST 'favorite'" do
      describe "responds to JSON request" do
        before do
          theStatus = double("Twitter::Status")
          theStatus.stub(:to_json).and_return({ text:'test status', retweetId: 'foo' }.to_json)
          theClient = double("Twitter::Client")
          theClient.should_receive(:favorite).with(1).and_return(theStatus)
          Twitter::Client.stub(:new).and_return(theClient)
          post 'favorite', favoriteId: 1, format: :json
        end
        
        it "returns http success" do
          response.should be_success
        end

        it "and returns valid JSON" do
          theResult = JSON.parse(response.body)
          theResult['text'].should eq("test status");
        end
      end
    end
  end
end
