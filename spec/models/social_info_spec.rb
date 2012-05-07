require 'spec_helper'

describe SocialInfo do

  before do
    @social_info = FactoryGirl.create(:social_info)
  end

  subject { @social_info }
  
  it { should respond_to(:twitter_name) }
  it { should respond_to(:facebook_page_url) }
  it { should respond_to(:web_url) }
  it { should respond_to(:hash_tags) }
  it { should respond_to(:youtube_url) } 
end
