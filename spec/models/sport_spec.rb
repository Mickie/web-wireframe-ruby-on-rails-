require 'spec_helper'

describe Sport do

  before do
    @sport = FactoryGirl.create(:sport)
  end

  subject { @sport }
  
  it { should respond_to(:name) }


end
