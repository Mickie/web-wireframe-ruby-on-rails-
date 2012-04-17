require 'spec_helper'

describe Event do
  before do
    mock_geocoding!
    @event = FactoryGirl.create(:event)
  end

  subject { @event }
  
  it { should respond_to(:name) }
  it { should respond_to(:event_date) }
  it { should respond_to(:event_time) }
  it { should respond_to(:home_team) }
  it { should respond_to(:visiting_team) } 
  it { should respond_to(:location) }
  it { should respond_to(:venues) }
  it { should respond_to(:game_watches) }

  it "should have a latitude and longitude in its location" do
    @event.location.latitude.should_not be_nil  
    @event.location.longitude.should_not be_nil
  end
  
  it "should be able to list the correct number of venues for the event" do
    4.times do
      theVenue = FactoryGirl.create(:venue)
      theGameWatch = FactoryGirl.create(:game_watch, venue:theVenue, event:@event)
    end
    @event.venues.length.should eq(4)
  end
end
