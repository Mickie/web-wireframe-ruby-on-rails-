require 'spec_helper'

describe "game_watches/new" do
  before(:each) do
    
    assign(:game_watch, stub_model(GameWatch,
      :name => "Superbowl Party",
      :event => nil,
      :venue => nil,
      :creator => nil
    ).as_new_record)
  end

  it "renders new game_watch form" do

    Event.should_receive(:all).at_least(1).times.and_return([])
    Venue.should_receive(:all).at_least(1).times.and_return([])
    User.should_receive(:all).at_least(1).times.and_return([])

    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => game_watches_path, :method => "post" do
      assert_select "input#game_watch_name", :name => "game_watch[name]"
      assert_select "select#game_watch_event_id", :name => "game_watch[event_id]" 
      assert_select "select#game_watch_venue_id", :name => "game_watch[venue_id]" 
      assert_select "select#game_watch_creator_id", :name => "game_watch[creator_id]" 
    end
  end
end
