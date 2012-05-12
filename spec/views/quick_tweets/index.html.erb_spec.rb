require 'spec_helper'

describe "quick_tweets/index" do
  before(:each) do
    @sport = stub_model(Sport, name:"Football");
    assign(:quick_tweets, [
      stub_model(QuickTweet,
        :sport => @sport,
        :name => "Name",
        :tweet => "Tweet",
        :happy => false
      ),
      stub_model(QuickTweet,
        :sport => @sport,
        :name => "Name",
        :tweet => "Tweet",
        :happy => false
      )
    ])
  end

  it "renders a list of quick_tweets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @sport.name.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Tweet".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
