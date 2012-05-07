require 'spec_helper'

describe "teams/new" do
  before(:each) do
    theStub = stub_model(Team,
      :name => "MyString",
      :sport => nil,
      :league => nil,
      :division => nil,
      :conference => nil,
      :location => nil,
      :affiliation => nil,
      :social_info => nil
    ).as_new_record
    theStub.build_location
    theStub.build_social_info
    
    assign(:team, theStub)
  end

  it "renders new team form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => teams_path, :method => "post" do
      assert_select "input#team_name", :name => "team[name]"
      assert_select "input#team_social_info_attributes_twitter_name", :name => "team[social_info_attributes][twitter_name]"
      assert_select "input#team_social_info_attributes_facebook_page_url", :name => "team[social_info_attributes][facebook_page_url]"
      assert_select "input#team_social_info_attributes_web_url", :name => "team[social_info_attributes][web_url]"
      assert_select "input#team_social_info_attributes_youtube_url", :name => "team[social_info_attributes][youtube_url]"

      assert_select "select#team_sport_id", :name => "team[sport_id]"
      assert_select "select#team_league_id", :name => "team[league_id]"
      assert_select "select#team_division_id", :name => "team[division_id]"
      assert_select "select#team_conference_id", :name => "team[conference_id]"
      assert_select "select#team_affiliation_id", :name => "team[affiliation_id]"

      assert_select "input#team_location_attributes_name", :name => "team[location_attributes][name]"
      assert_select "input#team_location_attributes_address1", :name => "team[location_attributes][address1]"
      assert_select "input#team_location_attributes_address2", :name => "team[location_attributes][address2]"
      assert_select "input#team_location_attributes_city", :name => "team[location_attributes][city]"
      assert_select "input#team_location_attributes_postal_code", :name => "team[location_attributes][postal_code]"
      assert_select "select#team_location_attributes_state_id", :name => "team[location_attributes][state_id]"
      assert_select "select#team_location_attributes_country_id", :name => "team[location_attributes][country_id]"
    end
    
    rendered.should have_selector('#commit')
  end
end
