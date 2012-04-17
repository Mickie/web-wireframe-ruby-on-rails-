require 'spec_helper'

describe Person do

  before do
    @person = FactoryGirl.create(:person)
  end

  subject { @person }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:home_town) }
  it { should respond_to(:home_school) }
  it { should respond_to(:position) }
  it { should respond_to(:team) }
  it { should respond_to(:social_info) }
  
  it "should require a first_name to validate" do
    @person.first_name = nil
    @person.should_not be_valid   
  end

  it "should require a last_name to validate" do
    @person.last_name = nil
    @person.should_not be_valid   
  end


end
