require 'spec_helper'

describe "people/index" do
  before(:each) do
    assign(:people, [
      stub_model(Person,
        :first_name => "First Name",
        :last_name => "Last Name",
        :home_town => "Home Town",
        :home_school => "Home School",
        :position => "Position"
      ),
      stub_model(Person,
        :first_name => "First Name",
        :last_name => "Last Name",
        :home_town => "Home Town",
        :home_school => "Home School",
        :position => "Position"
      )
    ])
  end

  it "renders a list of people" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Home Town".to_s, :count => 2
    assert_select "tr>td", :text => "Home School".to_s, :count => 2
    assert_select "tr>td", :text => "Position".to_s, :count => 2
  end
end
