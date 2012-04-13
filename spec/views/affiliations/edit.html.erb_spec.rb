require 'spec_helper'

describe "affiliations/edit" do
  before(:each) do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
    @social_info = FactoryGirl.create(:social_info)
    theStub = stub_model(Affiliation,
      :name => "MyString",
      :location => @location,
      :social_info => @social_info
    )
    @affiliation = assign(:affiliation, theStub)
  end

  it "renders the edit affiliation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => affiliations_path(@affiliation), :method => "post" do
      assert_select "input#affiliation_name", :name => "affiliation[name]"
      
      assert_select "input#affiliation_social_info_attributes_twitter_name", :name => "affiliation[social_info_attributes][twitter_name]"
      assert_select "input#affiliation_social_info_attributes_facebook_page_url", :name => "affiliation[social_info_attributes][facebook_page_url]"
      assert_select "input#affiliation_social_info_attributes_web_url", :name => "affiliation[social_info_attributes][web_url]"
      
      assert_select "input#affiliation_location_attributes_name", :name => "affiliation[location_attributes][name]"
      assert_select "input#affiliation_location_attributes_address1", :name => "affiliation[location_attributes][address1]"
      assert_select "input#affiliation_location_attributes_address2", :name => "affiliation[location_attributes][address2]"
      assert_select "input#affiliation_location_attributes_city", :name => "affiliation[location_attributes][city]"
      assert_select "input#affiliation_location_attributes_postal_code", :name => "affiliation[location_attributes][postal_code]"
      assert_select "select#affiliation_location_attributes_state_id", :name => "affiliation[location_attributes][state_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#affiliation_location_attributes_country_id", :name => "affiliation[location_attributes][country_id]" do
        assert_select "option[selected]"
      end
      
    end
  end
end
