require 'spec_helper'

describe "teams/index" do
  before(:each) do
    mock_geocoding!
    @league = FactoryGirl.create(:league)
    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
    assign(:teams, [
      stub_model(Team,
        :name => "Name",
        :sport => @league.sport,
        :league => @league,
        :division => nil,
        :conference => nil,
        :location => @location,
        :social_info => @social_info
      ),
      stub_model(Team,
        :name => "Name",
        :sport => @league.sport,
        :league => @league,
        :division => nil,
        :conference => nil,
        :location => @location,
        :social_info => @social_info
      )
    ])
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => @league.name, :count => 2
    assert_select "tr>td", :text => @league.sport.name, :count => 2
    assert_select "tr>td", :text => @location.city + "," + @location.state.name, :count => 2
    assert_select "tr>td", :text => @social_info.twitter_name, :count => 2
    assert_select "tr>td", :text => @social_info.facebook_page_url, :count => 2
    assert_select "tr>td", :text => @social_info.web_url, :count => 2
  end
end
