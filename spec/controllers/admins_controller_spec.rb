require 'spec_helper'

describe AdminsController do
  login_admin
  
  describe "admin profile page" do
    before do
      get :show, {:id => subject.current_admin.to_param}
    end 

    it "should return http success" do
      response.should be_success
    end

    it "should send the admin to the view" do
      assigns(:admin).should eq(subject.current_admin)
    end
  end

end
