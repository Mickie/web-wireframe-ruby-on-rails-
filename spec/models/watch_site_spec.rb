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
end
