require 'spec_helper'

describe "venues/index" do
  before(:each) do
    assign(:venues, [
      stub_model(Venue,
        :name => "Name",
        :social_info => stub_model(SocialInfo, twitter_name:"foo", facebook_page_url:"bar", web_url:"wilma"),
        :location => stub_model(Location, one_line_address:"100 Main"),
        :venue_type => stub_model(VenueType, name:"fred")
      ),
      stub_model(Venue,
        :name => "Name",
        :social_info => stub_model(SocialInfo, twitter_name:"foo", facebook_page_url:"bar", web_url:"wilma"),
        :location => stub_model(Location, one_line_address:"100 Main"),
        :venue_type => stub_model(VenueType, name:"fred")
      )
    ])
  end

  it "renders a list of venues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name", :count => 2
    assert_select "tr>td", :text => "fred", :count => 2
    assert_select "tr>td", :text => "100 Main", :count => 2
    assert_select "tr>td", :text => "foo", :count => 2
    assert_select "tr>td", :text => "bar", :count => 2
    assert_select "tr>td", :text => "wilma", :count => 2
  end
end
