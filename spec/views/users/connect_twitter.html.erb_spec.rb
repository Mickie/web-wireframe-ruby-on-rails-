require 'spec_helper'

describe "users/connect_twitter" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "joe@foo.com"
    ))
  end

  it "should ask to connect to twitter" do
    render
    rendered.should match(/twitter/i)
  end 
  
end
