require 'spec_helper'

describe FunFact do
  before do
    @funFact = FunFact.create(content:"content", name:"name")
  end

  subject { @funFact }
  
  it { should respond_to(:name) }
  it { should respond_to(:content) }

  it "should require a name to validate" do
    @funFact.name = nil
    @funFact.should_not be_valid   
  end

  it "should require content to validate" do
    @funFact.content = nil
    @funFact.should_not be_valid   
  end
end
