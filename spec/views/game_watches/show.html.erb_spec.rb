require 'spec_helper'

describe "game_watches/show" do
  before(:each) do
    @game_watch = assign(:game_watch, stub_model(GameWatch,
      :name => "Superbowl Party",
      :event => stub_model(Event, name:"Superbowl" ),
      :venue => stub_model(Venue, name:"Eat At Joes"),
      :creator => stub_model(User, email:"Sport Bob")
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Superbowl Party/)
    rendered.should match(/Superbowl/)
    rendered.should match(/Eat At Joes/)
    rendered.should match(/Sport Bob/)
  end
end
