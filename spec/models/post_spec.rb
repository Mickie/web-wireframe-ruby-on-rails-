require 'spec_helper'

describe Post do

  before do
    @post = FactoryGirl.create(:post)
  end

  subject { @post }
  
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:tailgate) }

end
