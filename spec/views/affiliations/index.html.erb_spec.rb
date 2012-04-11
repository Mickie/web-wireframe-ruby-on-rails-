require 'spec_helper'

describe "affiliations/index" do
  before(:each) do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
    assign(:affiliations, [
      stub_model(Affiliation,
        :name => "University of Notre Dame",
        :location => @location,
        :twitter_name => "Twitter Name",
        :facebook_page_url => "Facebook Page Url",
        :web_url => "Web Url"
      ),
      stub_model(Affiliation,
        :name => "University of Notre Dame",
        :location => @location,
        :twitter_name => "Twitter Name",
        :facebook_page_url => "Facebook Page Url",
        :web_url => "Web Url"
      )
    ])
  end

  it "renders a list of affiliations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "University of Notre Dame".to_s, :count => 2
    assert_select "tr>td", :text => "Twitter Name".to_s, :count => 2
    assert_select "tr>td", :text => "Facebook Page Url".to_s, :count => 2
    assert_select "tr>td", :text => "Web Url".to_s, :count => 2
    assert_select "tr>td", :text => @location.city, :count => 2
    assert_select "tr>td", :text => @location.state.abbreviation, :count => 2
  end
end
