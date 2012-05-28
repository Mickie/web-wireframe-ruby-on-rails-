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
  it { should respond_to(:game_watches) }
  it { should respond_to(:events) }
  it { should respond_to(:watch_sites) }
  it { should respond_to(:teams) }
  it { should respond_to(:tailgates) }
  
  it "should require a venue type" do
    @venue.venue_type_id = nil
    @venue.should_not be_valid
  end

  it "should have correct number of game_watches" do
    3.times do
      theGameWatch = FactoryGirl.create(:game_watch, venue:@venue)
    end
    @venue.game_watches.length.should eq(3)
  end
  
  it "should have correct number of events" do
    4.times do
      theGameWatch = FactoryGirl.create(:game_watch, venue:@venue)
    end
    @venue.events.length.should eq(4)
  end

  it "should have correct number of watch_sites" do
    2.times do
      theWatchSite = FactoryGirl.create(:watch_site, venue:@venue)
    end
    @venue.watch_sites.length.should eq(2)
  end
  
  it "should have correct number of teams" do
    3.times do
      theGameWatch = FactoryGirl.create(:watch_site, venue:@venue)
    end
    @venue.teams.length.should eq(3)
  end

  it "should have correct number of tailgates" do
    3.times do
      theTailgate = FactoryGirl.create(:tailgate)
      theTailgateVenue = TailgateVenue.create tailgate:theTailgate, venue:@venue
    end
    @venue.tailgates.length.should eq(3)
  end

end
