require 'spec_helper'

describe "affiliations/new" do
  before(:each) do
    theStubModel = stub_model(Affiliation,
      :name => "MyString",
      :location => nil,
      :twitter_name => "MyString",
      :facebook_page_url => "MyString",
      :web_url => "MyString"
    ).as_new_record
    theStubModel.build_location
    assign(:affiliation, theStubModel)
  end

  it "renders new affiliation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => affiliations_path, :method => "post" do
      assert_select "input#affiliation_name", :name => "affiliation[name]"
      assert_select "input#affiliation_twitter_name", :name => "affiliation[twitter_name]"
      assert_select "input#affiliation_facebook_page_url", :name => "affiliation[facebook_page_url]"
      assert_select "input#affiliation_web_url", :name => "affiliation[web_url]"

      assert_select "input#affiliation_location_attributes_name", :name => "affiliation[location_attributes][name]"
      assert_select "input#affiliation_location_attributes_address1", :name => "affiliation[location_attributes][address1]"
      assert_select "input#affiliation_location_attributes_address2", :name => "affiliation[location_attributes][address2]"
      assert_select "input#affiliation_location_attributes_city", :name => "affiliation[location_attributes][city]"
      assert_select "input#affiliation_location_attributes_postal_code", :name => "affiliation[location_attributes][postal_code]"
      assert_select "select#affiliation_location_attributes_state_id", :name => "affiliation[location_attributes][state_id]"
      assert_select "select#affiliation_location_attributes_country_id", :name => "affiliation[location_attributes][country_id]"

    end
  end
end
