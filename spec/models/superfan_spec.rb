require 'spec_helper'

describe Superfan do

  before do
    mock_geocoding!
    @superfan = FactoryGirl.create(:superfan)
  end

  subject { @superfan }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:home_town) }
  it { should respond_to(:home_school) }
  it { should respond_to(:position) }
  it { should respond_to(:team) }
  it { should respond_to(:social_info) }
  
  it "should require a first_name to validate" do
    @superfan.first_name = nil
    @superfan.should_not be_valid   
  end

  it "should require a last_name to validate" do
    @superfan.last_name = nil
    @superfan.should_not be_valid   
  end


end
