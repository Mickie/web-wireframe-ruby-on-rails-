require 'spec_helper'

describe "game_watches/index" do
  before(:each) do
    assign(:game_watches, [
      stub_model(GameWatch,
        :name => "Superbowl Party",
        :event => stub_model(Event, name:"Superbowl" ),
        :venue => stub_model(Venue, name:"Eat At Joes"),
        :creator => stub_model(User, email:"Sport Bob")
      ),
      stub_model(GameWatch,
        :name => "Superbowl Party",
        :event => stub_model(Event, name:"Superbowl" ),
        :venue => stub_model(Venue, name:"Eat At Joes"),
        :creator => stub_model(User, email:"Sport Bob")
      )
    ])
  end

  it "renders a list of game_watches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Superbowl Party", :count => 2
    assert_select "tr>td", :text => "Superbowl", :count => 2
    assert_select "tr>td", :text => "Eat At Joes", :count => 2
    assert_select "tr>td", :text => "Sport Bob", :count => 2
  end
end
