require 'spec_helper'

describe "tailgates/edit" do
  before(:each) do
    mock_geocoding!
    @team = FactoryGirl.create(:team)
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "MyString",
      :user => nil,
      :team => @team
    ))
  end

  it "renders the edit tailgate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tailgates_path(@tailgate), :method => "post" do
      assert_select "input#tailgate_name", :name => "tailgate[name]"
      assert_select "input#tailgate_user_id", :name => "tailgate[user_id]"

      assert_select "select#tailgate_team_id", :name => "tailgate[team_id]" do
        assert_select "option[selected]"
      end
    end
  end
end
