require 'spec_helper'

describe "User Pages" do
  
  describe "Sign in page" do
    it "should respond to a request" do
      get new_user_session_path
      response.status.should be(200)
    end
  end
end
