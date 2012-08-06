require 'spec_helper'

describe "user_brags/new" do
  before(:each) do
    assign(:user_brag, stub_model(UserBrag,
      :user => nil,
      :brag => nil,
      :type => 1
    ).as_new_record)
  end

  it "renders new user_brag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_brags_path, :method => "post" do
      assert_select "input#user_brag_user", :name => "user_brag[user]"
      assert_select "input#user_brag_brag", :name => "user_brag[brag]"
      assert_select "input#user_brag_type", :name => "user_brag[type]"
    end
  end
end
