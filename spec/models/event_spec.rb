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

  it "should have a latitude and longitude in its location" do
    @event.location.latitude.should_not be_nil  
    @event.location.longitude.should_not be_nil
  end
end
