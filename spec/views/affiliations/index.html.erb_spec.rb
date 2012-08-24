require 'spec_helper'

describe "affiliations/index" do
  before(:each) do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
    assign(:affiliations, [
      stub_model(Affiliation,
        :name => "University of Notre Dame",
        :location => @location,
        :social_info => @social_info
      ),
      stub_model(Affiliation,
        :name => "University of Notre Dame",
        :location => @location,
        :social_info => @social_info
      )
    ])
  end

  it "renders a list of affiliations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "University of Notre Dame".to_s, :count => 2
    assert_select "tr>td", :text => @social_info.twitter_name, :count => 2
    assert_select "tr>td", :text => @social_info.facebook_page_url, :count => 2
    assert_select "tr>td", :text => @social_info.web_url, :count => 2
    assert_select "tr>td", :text => @location.city, :count => 2
    assert_select "tr>td", :text => @location.state.name, :count => 2
  end
end
