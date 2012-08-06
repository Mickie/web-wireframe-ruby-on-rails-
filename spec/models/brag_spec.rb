require 'spec_helper'

describe Brag do
  before do
    @brag = FactoryGirl.create(:brag)
  end

  subject { @brag }
  
  it { should respond_to(:content) }
end
