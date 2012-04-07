require 'spec_helper'

describe Division do
  before do
    @division = FactoryGirl.create(:division)
  end

  subject { @division }
  
  it { should respond_to(:name) }
  it { should respond_to(:conference) }
end
