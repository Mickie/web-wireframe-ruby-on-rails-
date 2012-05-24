require 'spec_helper'

describe Tailgate do
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
  end 

  subject { @tailgate }
  
  it { should respond_to(:name) }
  it { should respond_to(:team) }
  it { should respond_to(:user) }
  
  it "should require a name to validate" do
    @tailgate.name = nil
    @tailgate.should_not be_valid   
  end

  it "should require a user to validate" do
    @tailgate.user = nil
    @tailgate.should_not be_valid   
  end
end
