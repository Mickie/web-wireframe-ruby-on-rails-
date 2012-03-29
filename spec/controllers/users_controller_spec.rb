require 'spec_helper'

describe UsersController do
  login_user
  
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  describe "user profile page" do
    it "should return http success" do
      visit user_path(subject.current_user)
      response.should be_success
    end
  end

end
