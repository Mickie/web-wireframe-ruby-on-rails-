require 'spec_helper'

describe "watch_sites/index" do
  before(:each) do
    assign(:watch_sites, [
      stub_model(WatchSite,
        :name => "Name",
        :team => stub_model(Team, name:"Irish"),
        :venue => stub_model(Venue, name:"Joes")
      ),
      stub_model(WatchSite,
        :name => "Name",
        :team => stub_model(Team, name:"Irish"),
        :venue => stub_model(Venue, name:"Joes")
      )
    ])
  end

  it "renders a list of watch_sites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name", :count => 2
    assert_select "tr>td", :text => "Irish", :count => 2
    assert_select "tr>td", :text => "Joes", :count => 2
  end
end
