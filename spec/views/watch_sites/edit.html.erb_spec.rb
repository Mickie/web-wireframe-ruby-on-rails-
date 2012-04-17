require 'spec_helper'

describe "watch_sites/edit" do
  before(:each) do
    @watch_site = assign(:watch_site, stub_model(WatchSite,
      :name => "MyString",
      :team => nil,
      :venue => nil
    ))
  end

  it "renders the edit watch_site form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => watch_sites_path(@watch_site), :method => "post" do
      assert_select "input#watch_site_name", :name => "watch_site[name]"
      assert_select "input#watch_site_team", :name => "watch_site[team]"
      assert_select "input#watch_site_venue", :name => "watch_site[venue]"
    end
  end
end
