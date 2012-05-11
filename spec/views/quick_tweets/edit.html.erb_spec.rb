require 'spec_helper'

describe "quick_tweets/edit" do
  before(:each) do
    @sport = FactoryGirl.create(:sport)
    @quick_tweet = assign(:quick_tweet, stub_model(QuickTweet,
      :sport_id => @sport.id,
      :name => "MyString",
      :tweet => "MyString",
      :happy => false
    ))
  end

  it "renders the edit quick_tweet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => quick_tweets_path(@quick_tweet), :method => "post" do
      assert_select "input#quick_tweet_name", :name => "quick_tweet[name]"
      assert_select "input#quick_tweet_tweet", :name => "quick_tweet[tweet]"
      assert_select "input#quick_tweet_happy", :name => "quick_tweet[happy]"

      assert_select "select#quick_tweet_sport_id", :name => "quick_tweet[sport_id]" do
        assert_select "option[selected]"
      end

    end
  end
end
