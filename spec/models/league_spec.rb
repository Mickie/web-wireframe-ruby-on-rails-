require 'spec_helper'

describe League do
  before do
    @league = FactoryGirl.create(:league)
  end

  subject { @league }
  
  it { should respond_to(:name) }
  it { should respond_to(:sport) }
end
