require 'spec_helper'

describe "teams/edit" do
  before(:each) do
    @team = assign(:team, stub_model(Team,
      :name => "Seahawks",
      :sport => nil,
      :league => nil,
      :division => nil,
      :conference => nil,
      :location => nil,
      :twitter_name => "@seahawks",
      :facebook_page_url => "http://facebook.com/seahawks",
      :web_url => "http://www.seahawks.com"
    ))
  end

  it "renders the edit team form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => teams_path(@team), :method => "post" do
      assert_select "input#team_name", :name => "team[name]"
      assert_select "input#team_sport", :name => "team[sport]"
      assert_select "input#team_league", :name => "team[league]"
      assert_select "input#team_division", :name => "team[division]"
      assert_select "input#team_conference", :name => "team[conference]"
      assert_select "input#team_location", :name => "team[location]"
      assert_select "input#team_twitter_name", :name => "team[twitter_name]"
      assert_select "input#team_facebook_page_url", :name => "team[facebook_page_url]"
      assert_select "input#team_web_url", :name => "team[web_url]"
    end
  end
end
