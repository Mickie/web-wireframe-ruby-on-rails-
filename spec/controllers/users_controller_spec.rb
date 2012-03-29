require 'spec_helper'

describe UsersController do
  login_user

  describe "GET 'show'" do
    it "returns http success" do
      visit user_path(subject.current_user)
      response.should be_success
    end
  end

end
