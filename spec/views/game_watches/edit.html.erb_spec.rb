require 'spec_helper'

describe "game_watches/edit" do
  before(:each) do
    @theStubEvent = stub_model(Event, name:"Superbowl", id:1 )
    @theStubVenue = stub_model(Venue, name:"Eat At Joes", id:1)
    @theStubUser = stub_model(User, email:"Sport Bob", id:1)
    
    @game_watch = assign(:game_watch, stub_model(GameWatch,
      :name => "Superbowl Party",
      :event => @theStubEvent,
      :venue => @theStubVenue,
      :creator => @theStubUser
    ))
  end

  it "renders the edit game_watch form" do
    Event.should_receive(:all).at_least(1).times.and_return([@theStubEvent])
    Venue.should_receive(:all).at_least(1).times.and_return([@theStubVenue])
    User.should_receive(:all).at_least(1).times.and_return([@theStubUser])


    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => game_watches_path(@game_watch), :method => "post" do
      assert_select "input#game_watch_name", :name => "game_watch[name]"
      
      assert_select "select#game_watch_event_id", :name => "game_watch[event_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#game_watch_venue_id", :name => "game_watch[venue_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#game_watch_creator_id", :name => "game_watch[creator_id]" do
        assert_select "option[selected]"
      end
    end
  end
end
