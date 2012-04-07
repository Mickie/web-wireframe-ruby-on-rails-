require 'spec_helper'

describe "users/show.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "joe@foo.com"
    ))
  end

  it "should include the username" do
    render
    rendered.should match(/joe@foo.com/)
  end
end
