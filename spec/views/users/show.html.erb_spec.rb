require 'spec_helper'

describe "users/show" do 
  before(:each) do
    mock_geocoding!

    @user = assign( :user, 
                    stub_model(User,
                               :email => "joe@foo.com"
                    ))
  end

  describe "partials" do

  end
end
