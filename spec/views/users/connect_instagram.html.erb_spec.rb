require 'spec_helper'

describe "users/connect_instagram" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "joe@foo.com"
    ))
  end

  it "should ask to connect to instagram" do
    render
    rendered.should match(/instagram/i)
  end 
  
end
