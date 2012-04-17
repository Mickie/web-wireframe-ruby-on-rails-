require 'spec_helper'

describe Venue do

  before do
    mock_geocoding!
    @venue = FactoryGirl.create(:venue)
  end

  subject { @venue }
  
  it { should respond_to(:name) }
  it { should respond_to(:venue_type) }
  it { should respond_to(:location) }
  it { should respond_to(:social_info) }
  it { should respond_to(:events) }
  it { should respond_to(:game_watches) }
  
  it "should require a venue type" do
    @venue.venue_type_id = nil
    @venue.should_not be_valid
  end
  
  it "should have correct number of events" do
    4.times do
      theEvent = FactoryGirl.create(:event)
      theGameWatch = FactoryGirl.create(:game_watch, venue:@venue, event:theEvent)
    end
    @venue.events.length.should eq(4)
  end
end
