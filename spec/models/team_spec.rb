require 'spec_helper'

describe Team do
  before do
    mock_geocoding!
    @team = FactoryGirl.create(:team)
  end

  subject { @team }
  
  it { should respond_to(:name) }
  it { should respond_to(:sport) }
  it { should respond_to(:league) }
  it { should respond_to(:conference) }
  it { should respond_to(:division) }
  it { should respond_to(:location) }
  it { should respond_to(:affiliation) }
  it { should respond_to(:twitter_name) }
  it { should respond_to(:facebook_page_url) }
  it { should respond_to(:web_url) }

  it "should have a latitude and longitude in its location" do
    @team.location.latitude.should_not be_nil  
    @team.location.longitude.should_not be_nil
  end
end
