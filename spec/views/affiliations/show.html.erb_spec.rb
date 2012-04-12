require 'spec_helper'

describe "affiliations/show" do
  before(:each) do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
    @affiliation = assign(:affiliation, stub_model(Affiliation,
      :name => "Name",
      :location => @location,
      :social_info => @social_info
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(/#{@social_info.twitter_name}/)
    rendered.should match(/#{@social_info.facebook_page_url}/)
    rendered.should match(/#{@social_info.web_url}/)
  end
end
