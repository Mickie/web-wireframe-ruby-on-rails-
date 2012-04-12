require 'spec_helper'

describe "venues/show" do
  before(:each) do
    mock_geocoding!
    @venue_type = FactoryGirl.create(:venue_type)
    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
    @venue = assign(:venue, stub_model(Venue,
      :name => "Name",
      :social_info => @social_info,
      :location => @location,
      :venue_type => @venue_type
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/#{@venue_type.name}/)
    rendered.should match(/#{@social_info.twitter_name}/)
    rendered.should match(/#{@social_info.facebook_page_url}/)
    rendered.should match(/#{@social_info.web_url}/)
    rendered.should match(/#{@location.one_line_address}/)
  end
end
