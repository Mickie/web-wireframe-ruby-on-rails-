require 'spec_helper'

describe "user_brags/index" do
  before(:each) do
    assign(:user_brags, [
      stub_model(UserBrag,
        :user => nil,
        :brag => nil,
        :type => 1
      ),
      stub_model(UserBrag,
        :user => nil,
        :brag => nil,
        :type => 1
      )
    ])
  end

  it "renders a list of user_brags" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
