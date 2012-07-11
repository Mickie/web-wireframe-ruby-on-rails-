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
  it { should respond_to(:shortened_content) }

  describe "shortened_content" do
    
    it "should handle already short content" do
      @post.content = "this is short"
      @post.shortened_content.should eq(@post.content)
    end
  
    it "should ellipsis long content" do
      @post.content = "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 "
      theResult = @post.shortened_content
      theResult.length.should eq(119)
      theResult[theResult.length - 3, theResult.length - 1].should eq("...")
    end

  end
end
