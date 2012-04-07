require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "joe@foo.com"
    ))
  end

  it "should include the email" do
    render
    rendered.should match(/joe@foo.com/)
  end
end
