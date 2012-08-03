require 'spec_helper'

describe UsersController do
  login_user
  
  describe "user profile page" do
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

end
