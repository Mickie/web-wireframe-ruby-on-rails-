require 'spec_helper'

describe "quick_tweets/show" do
  before(:each) do
    
    @quick_tweet = assign(:quick_tweet, stub_model(QuickTweet,
      :sport => stub_model(Sport, name:"Football"),
      :name => "DisplayName",
      :tweet => "Tweet",
      :happy => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/DisplayName/)
    rendered.should match(/Tweet/)
    rendered.should match(/false/)
  end
end
