require 'spec_helper'

describe "teams/index" do
  before(:each) do
    @league = FactoryGirl.create(:league)
    @location = FactoryGirl.create(:location)
    assign(:teams, [
      stub_model(Team,
        :name => "Name",
        :sport => @league.sport,
        :league => @league,
        :division => nil,
        :conference => nil,
        :location => @location,
        :twitter_name => "Twitter Name",
        :facebook_page_url => "Facebook Page Url",
        :web_url => "Web Url"
      ),
      stub_model(Team,
        :name => "Name",
        :sport => @league.sport,
        :league => @league,
        :division => nil,
        :conference => nil,
        :location => @location,
        :twitter_name => "Twitter Name",
        :facebook_page_url => "Facebook Page Url",
        :web_url => "Web Url"
      )
    ])
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => @league.name, :count => 2
    assert_select "tr>td", :text => @league.sport.name, :count => 2
    assert_select "tr>td", :text => @location.city, :count => 2
    assert_select "tr>td", :text => @location.state.name, :count => 2
    assert_select "tr>td", :text => "Twitter Name".to_s, :count => 2
    assert_select "tr>td", :text => "Facebook Page Url".to_s, :count => 2
    assert_select "tr>td", :text => "Web Url".to_s, :count => 2
  end
end
