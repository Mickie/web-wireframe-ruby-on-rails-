require 'spec_helper'

describe TailgateVenue do
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
    @venue = FactoryGirl.create(:venue)
    @tailgate_venue = TailgateVenue.new(tailgate:@tailgate, venue:@venue)
  end

  subject { @tailgate_venue }
  
  it { should respond_to(:tailgate) }
  it { should respond_to(:venue) }
  it { should respond_to(:venue_address) }
  it { should respond_to(:venue_address_changed?) }
end
