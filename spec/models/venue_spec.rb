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
  
  it "should require a venue type" do
    @venue.venue_type_id = nil
    @venue.should_not be_valid
  end
end
