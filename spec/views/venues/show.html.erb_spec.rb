require 'spec_helper'

describe "venues/show" do
  before(:each) do
    @venue = assign(:venue, stub_model(Venue,
      :name => "Name",
      :social_info => stub_model(SocialInfo, twitter_name:"foo", facebook_page_url:"bar", web_url:"wilma"),
      :location => stub_model(Location, one_line_address:"100 Main"),
      :venue_type => stub_model(VenueType, name:"fred")
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/fred/)
    rendered.should match(/foo/)
    rendered.should match(/bar/)
    rendered.should match(/wilma/)
    rendered.should match(/100 Main/)
  end
end
