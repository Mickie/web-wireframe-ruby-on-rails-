require 'spec_helper'

describe UsersController do
  login_user
  
  describe "user profile page" do
    before do
      get :show, {:id => subject.current_user.to_param}
    end 

    it "should return http success" do
      response.should be_success
    end

    it "should send the user to the view" do
      assigns(:user).should eq(subject.current_user)
    end
  end

end
