require 'spec_helper'

describe "venues/index" do
  before(:each) do
    mock_geocoding!
    @venue_type = FactoryGirl.create(:venue_type)
    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
    assign(:venues, [
      stub_model(Venue,
        :name => "Name",
        :social_info => @social_info,
        :location => @location,
        :venue_type => @venue_type
      ),
      stub_model(Venue,
        :name => "Name",
        :social_info => @social_info,
        :location => @location,
        :venue_type => @venue_type
      )
    ])
  end

  it "renders a list of venues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => @venue_type.name, :count => 2
    assert_select "tr>td", :text => @location.one_line_address, :count => 2
    assert_select "tr>td", :text => @social_info.twitter_name, :count => 2
    assert_select "tr>td", :text => @social_info.facebook_page_url, :count => 2
    assert_select "tr>td", :text => @social_info.web_url, :count => 2
  end
end
