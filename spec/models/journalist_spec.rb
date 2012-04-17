require 'spec_helper'

describe Journalist do

  before do
    mock_geocoding!
    @journalist = FactoryGirl.create(:journalist)
  end

  subject { @journalist }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:home_town) }
  it { should respond_to(:home_school) }
  it { should respond_to(:position) }
  it { should respond_to(:team) }
  it { should respond_to(:social_info) }
  
  it "should require a first_name to validate" do
    @journalist.first_name = nil
    @journalist.should_not be_valid   
  end

  it "should require a last_name to validate" do
    @journalist.last_name = nil
    @journalist.should_not be_valid   
  end


end
