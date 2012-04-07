require 'spec_helper'

describe Conference do
  before do
    @conference = FactoryGirl.create(:conference)
  end

  subject { @conference }
  
  it { should respond_to(:name) }
  it { should respond_to(:league) }
end
