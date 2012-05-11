require 'spec_helper'

describe QuickTweet do
  before do
    @quick_tweet = FactoryGirl.create(:quick_tweet)
  end

  subject { @quick_tweet }
  
  it { should respond_to(:name) }
  it { should respond_to(:tweet) }
  it { should respond_to(:happy) }
  it { should respond_to(:sport) }
end
