require 'spec_helper'

describe FanzoTip do
  before do
    @fanzoTip = FanzoTip.create(content:"content", name:"name")
  end

  subject { @fanzoTip }
  
  it { should respond_to(:name) }
  it { should respond_to(:content) }

  it "should require a name to validate" do
    @fanzoTip.name = nil
    @fanzoTip.should_not be_valid   
  end

  it "should require content to validate" do
    @fanzoTip.content = nil
    @fanzoTip.should_not be_valid   
  end
end
