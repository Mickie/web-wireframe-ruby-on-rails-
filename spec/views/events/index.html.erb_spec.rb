require 'spec_helper'

describe "events/index" do
  before(:each) do
    assign(:events, [
      stub_model(Event,
        :name => "Superbowl",
        :home_team => stub_model(Team, name:"Seahawks"),
        :visiting_team => stub_model(Team, name:"Cowboys"),
        :location => stub_model(Location, one_line_address:"100 Main")
      ),
      stub_model(Event,
        :name => "Superbowl",
        :home_team => stub_model(Team, name:"Seahawks"),
        :visiting_team => stub_model(Team, name:"Cowboys"),
        :location => stub_model(Location, one_line_address:"100 Main")
      )
    ])
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Superbowl".to_s, :count => 2
    assert_select "tr>td", :text => "Seahawks", :count => 2
    assert_select "tr>td", :text => "Cowboys", :count => 2
    assert_select "tr>td", :text => "100 Main", :count => 2
  end
end
