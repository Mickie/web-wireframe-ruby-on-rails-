require 'spec_helper'

describe Athlete do

  before do
    mock_geocoding!
    @athlete = FactoryGirl.build(:athlete)
  end

  subject { @athlete }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:home_town) }
  it { should respond_to(:home_school) }
  it { should respond_to(:position) }
  it { should respond_to(:team) }
  it { should respond_to(:social_info) }
  
  it "should require a first_name to validate" do
    @athlete.first_name = nil
    @athlete.should_not be_valid   
  end

  it "should require a last_name to validate" do
    @athlete.last_name = nil
    @athlete.should_not be_valid   
  end

  it "should require a position to validate" do
    @athlete.position = nil
    @athlete.should_not be_valid
  end

end
