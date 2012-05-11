require 'spec_helper'

describe "quick_tweets/new" do
  before(:each) do
    assign(:quick_tweet, stub_model(QuickTweet,
      :sport => nil,
      :name => "MyString",
      :tweet => "MyString",
      :happy => false
    ).as_new_record)
  end

  it "renders new quick_tweet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => quick_tweets_path, :method => "post" do
      assert_select "input#quick_tweet_name", :name => "quick_tweet[name]"
      assert_select "input#quick_tweet_tweet", :name => "quick_tweet[tweet]"
      assert_select "input#quick_tweet_happy", :name => "quick_tweet[happy]"

      assert_select "select#quick_tweet_sport_id", :name => "quick_tweet[sport_id]"
    end
  end
end
