require 'spec_helper'

describe UsersController do
  
  describe "user profile page" do
    login_user

    before do
      mock_geocoding!
    end 

    describe "goes to the right locations" do
      before do
        get :show, {id: subject.current_user.to_param}
      end 

      it "should return http success" do
        response.should be_success
      end
  
      it "should send the user to the view" do
        assigns(:user).should eq(subject.current_user)
      end
    end
    
  end

  describe "connect twitter page" do
    login_user

    before do
      get :connect_twitter, {id: subject.current_user.to_param}
    end

    it "should return http success" do
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(subject.current_user)
    end

  end

  describe "connect instagram page" do
    login_user

    before do
      get :connect_instagram, { id: subject.current_user.to_param }
    end

    it "should return http success" do
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(subject.current_user)
    end

  end

  describe "client facebook login with existing user" do
    let(:existing_user) { FactoryGirl.create(:user, facebook_user_id: "1234")}
    
    before do
      User.should_not_receive(:createUserFromProfile)
      add_xhr_headers
      post :client_facebook_login, { facebook_user_id: existing_user.facebook_user_id, facebook_access_token: "54321" }, format: :json
    end

    it "should return http success" do
      response.status.should eq(200)
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(existing_user)
    end

  end

  describe "client facebook login with new user" do
    let(:new_user) { FactoryGirl.create(:user) }   
   
    before do
      User.should_receive(:createUserFromProfile).once.with("12345", "54321").and_return(new_user)
      add_xhr_headers
      post :client_facebook_login, { facebook_user_id: "12345", facebook_access_token: "54321" }, format: :json
    end

    it "should return http success" do
      response.status.should eq(200)
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(new_user)
    end

  end


end
