require 'spec_helper'

describe "admins/show" do
  before(:each) do
    @admin = assign(:admin, stub_model(Admin,
      :email => "admin@foo.com"
    ))
  end

  it "should include the email" do
    render
    rendered.should match(/admin@foo.com/)
  end
end
