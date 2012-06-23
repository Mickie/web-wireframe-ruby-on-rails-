require 'spec_helper'

describe Post do

  before do
    mock_geocoding!
    
    theTailgate = FactoryGirl.create(:tailgate)
    @post = FactoryGirl.create(:post, tailgate:theTailgate, user:theTailgate.user)
  end

  subject { @post }
  
  it { should respond_to(:content) }
  it { should respond_to(:tailgate) }
  it { should respond_to(:user) }

end
