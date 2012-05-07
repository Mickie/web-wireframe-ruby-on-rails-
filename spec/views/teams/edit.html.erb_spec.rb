require 'spec_helper'

describe "teams/edit" do
  before(:each) do
    mock_geocoding!
    
    @sport = FactoryGirl.create(:sport)
    @league = FactoryGirl.create(:league)
    @division = FactoryGirl.create(:division)
    @conference = FactoryGirl.create(:conference)
    @affiliation = FactoryGirl.create(:affiliation)
    theStub = stub_model(Team,
      :name => "Seahawks",
      :sport_id => @sport.id,
      :league_id => @league.id,
      :division_id => @division.id,
      :conference_id => @conference.id,
      :affiliation_id => @affiliation.id, 
      :location => nil,
      :social_info => nil
    )
    theStub.build_location
    theStub.build_social_info
      
    @team = assign(:team, theStub)
  end

  it "renders the edit team form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => teams_path(@team), :method => "post" do
      assert_select "input#team_name", :name => "team[name]"
      assert_select "input#team_social_info_attributes_twitter_name", :name => "team[social_info_attributes][twitter_name]"
      assert_select "input#team_social_info_attributes_facebook_page_url", :name => "team[social_info_attributes][facebook_page_url]"
      assert_select "input#team_social_info_attributes_web_url", :name => "team[social_info_attributes][web_url]"
      assert_select "input#team_social_info_attributes_youtube_url", :name => "team[social_info_attributes][youtube_url]"

      assert_select "select#team_sport_id", :name => "team[sport_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#team_league_id", :name => "team[league_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#team_division_id", :name => "team[division_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#team_conference_id", :name => "team[conference_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#team_affiliation_id", :name => "team[affiliation_id]" do
        assert_select "option[selected]"
      end

      assert_select "input#team_location_attributes_name", :name => "team[location_attributes][name]"
      assert_select "input#team_location_attributes_address1", :name => "team[location_attributes][address1]"
      assert_select "input#team_location_attributes_address2", :name => "team[location_attributes][address2]"
      assert_select "input#team_location_attributes_city", :name => "team[location_attributes][city]"
      assert_select "input#team_location_attributes_postal_code", :name => "team[location_attributes][postal_code]"
      assert_select "select#team_location_attributes_state_id", :name => "team[location_attributes][state_id]"
      assert_select "select#team_location_attributes_country_id", :name => "team[location_attributes][country_id]"
    end
  end
end
