require 'spec_helper'

describe Affiliation do
  before do
    mock_geocoding!
    @affiliation = FactoryGirl.create(:affiliation)
  end

  subject { @affiliation }
  
  it { should respond_to(:name) }
  it { should respond_to(:location) }
  it { should respond_to(:twitter_name) }
  it { should respond_to(:facebook_page_url) }
  it { should respond_to(:web_url) }
  it { should respond_to(:teams) }

  it "should have a latitude and longitude in its location" do
    @affiliation.location.latitude.should_not be_nil  
    @affiliation.location.longitude.should_not be_nil
  end
end
