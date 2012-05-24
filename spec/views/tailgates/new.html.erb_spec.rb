require 'spec_helper'

describe "tailgates/new" do
  before(:each) do
    assign(:tailgate, stub_model(Tailgate,
      :name => "MyString",
      :user => nil,
      :team => nil
    ).as_new_record)
  end

  it "renders new tailgate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tailgates_path, :method => "post" do
      assert_select "input#tailgate_name", :name => "tailgate[name]"
      assert_select "input#tailgate_user_id", :name => "tailgate[user_id]"

      assert_select "select#tailgate_team_id", :name => "tailgate[team_id]"
    end
  end
end
