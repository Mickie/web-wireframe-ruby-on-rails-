require 'spec_helper'

describe "venues/new" do
  before(:each) do
    theStub = stub_model(Venue,
      :name => "MyString",
      :social_info => nil,
      :location => nil,
      :venue_type => nil
    ).as_new_record
    theStub.build_location
    theStub.build_social_info    
    assign(:venue, theStub)
  end

  it "renders new venue form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => venues_path, :method => "post" do
      assert_select "input#venue_name", :name => "venue[name]"

      assert_select "input#venue_social_info_attributes_twitter_name", :name => "venue[social_info_attributes][twitter_name]"
      assert_select "input#venue_social_info_attributes_facebook_page_url", :name => "venue[social_info_attributes][facebook_page_url]"
      assert_select "input#venue_social_info_attributes_web_url", :name => "venue[social_info_attributes][web_url]"

      assert_select "input#venue_location_attributes_name", :name => "venue[location_attributes][name]"
      assert_select "input#venue_location_attributes_address1", :name => "venue[location_attributes][address1]"
      assert_select "input#venue_location_attributes_address2", :name => "venue[location_attributes][address2]"
      assert_select "input#venue_location_attributes_city", :name => "venue[location_attributes][city]"
      assert_select "input#venue_location_attributes_postal_code", :name => "venue[location_attributes][postal_code]"
      assert_select "select#venue_location_attributes_state_id", :name => "venue[location_attributes][state_id]"
      assert_select "select#venue_location_attributes_country_id", :name => "venue[location_attributes][country_id]"

      assert_select "select#venue_venue_type_id", :name => "venue[venue_type_id]" 
    end
  end
end
