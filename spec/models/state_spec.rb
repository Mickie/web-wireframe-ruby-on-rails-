require 'spec_helper'

describe State do
  before do
    @state = FactoryGirl.create(:state)
  end

  subject { @state }
  
  it { should respond_to(:name) }
  it { should respond_to(:abbreviation) }
end
