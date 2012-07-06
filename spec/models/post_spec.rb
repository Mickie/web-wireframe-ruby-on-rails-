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
  it { should respond_to(:twitter_id) }
  it { should respond_to(:twitter_flag) }
  it { should respond_to(:twitter_retweet_id) }
  it { should respond_to(:twitter_reply_id) }
  it { should respond_to(:facebook_flag) }
  it { should respond_to(:facebook_id) }

end
