require 'spec_helper'

describe WatchSite do
  before do
    mock_geocoding!
    @watch_site = FactoryGirl.build(:watch_site)
  end

  subject { @watch_site }
  
  it { should respond_to(:name) }
  it { should respond_to(:venue) }
  it { should respond_to(:team) } 
  
  it "should store latitude and longitude" do
    @watch_site.save
    @watch_site.latitude.should_not be_nil
    @watch_site.longitude.should_not be_nil
  end

  it "should store latitude and longitude when venue already exists" do
    @watch_site.venue.save
    @watch_site.save
    @watch_site.latitude.should_not be_nil
    @watch_site.longitude.should_not be_nil
  end

end
