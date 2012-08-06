require 'spec_helper'

describe "user_brags/show" do
  before(:each) do
    @user_brag = assign(:user_brag, stub_model(UserBrag,
      :user => nil,
      :brag => nil,
      :type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
  end
end
