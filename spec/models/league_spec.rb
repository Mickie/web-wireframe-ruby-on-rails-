require 'spec_helper'

describe League do
  before do
    @league = FactoryGirl.create(:league)
  end

  subject { @league }
  
  it { should respond_to(:name) }
  it { should respond_to(:sport) }
  it { should respond_to(:visible) }
  it { should respond_to(:teams) }
  it { should respond_to(:conferences) }
  it { should respond_to(:divisions) }
  
  it "should have visible named scope" do
    visibleLeague = FactoryGirl.create(:league, visible:true)
    League.visible.should include(visibleLeague)
    League.visible.should_not include(@league)
  end
end
