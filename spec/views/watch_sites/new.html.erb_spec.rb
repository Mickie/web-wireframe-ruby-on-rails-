require 'spec_helper'

describe "watch_sites/new" do
  before(:each) do
    assign(:watch_site, stub_model(WatchSite,
      :name => "MyString",
      :team => nil,
      :venue => nil
    ).as_new_record)
  end

  it "renders new watch_site form" do
    Team.should_receive(:all).at_least(1).times.and_return([])
    Venue.should_receive(:order).at_least(1).times.and_return(Venue)

    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => watch_sites_path, :method => "post" do
      assert_select "input#watch_site_name", :name => "watch_site[name]"
      assert_select "select#watch_site_team_id", :name => "watch_site[team_id]"
      assert_select "select#watch_site_venue_id", :name => "watch_site[venue_id]"
    end
  end
end
