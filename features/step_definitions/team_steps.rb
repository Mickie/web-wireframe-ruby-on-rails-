
When /^I edit the team$/ do
  fill_in "Name",    with: "Sounders"
  click_button "commit"
  page.should have_content('Team was successfully updated')
end

When /^I create a new team$/ do 
  fill_in "team_name",    with: @new_team.name
  select @edit_sport.name, from: 'team[sport_id]'
  select @edit_league.name, from: 'team[league_id]'
  select @edit_conference.name, from: 'team[conference_id]'
  select @edit_division.name, from: 'team[division_id]'

  fill_in "team_social_info_attributes_twitter_name",    with: @new_team.social_info.twitter_name
  fill_in "team_social_info_attributes_facebook_page_url",    with: @new_team.social_info.facebook_page_url
  fill_in "team_social_info_attributes_web_url",    with: @new_team.social_info.web_url


  fill_in "team_location_attributes_name", with: @new_team.location.name
  fill_in "team_location_attributes_address1", with: @new_team.location.address1
  fill_in "team_location_attributes_address2", with: @new_team.location.address2
  fill_in "team_location_attributes_city", with: @new_team.location.city
  fill_in "team_location_attributes_postal_code", with: @new_team.location.postal_code
  select @edit_team.location.state.name, from: 'team[location_attributes][state_id]'
  select @edit_team.location.country.name, from: 'team[location_attributes][country_id]'

  click_button "commit"
end


Then /^the changes to the team should be saved$/ do
  @edit_team.reload
  @edit_team.name.should == "Sounders"
end

Then /^I should see the details of the new team$/ do
  page.should have_content(@new_team.name)
  page.should have_content(@new_team.social_info.twitter_name)
  page.should have_content(@new_team.social_info.facebook_page_url)
  page.should have_content(@new_team.social_info.web_url)
end

Then /^I should be able to associate other resources with the team$/ do
  page.should have_selector("#team_sport_id")
  page.should have_selector("#team_league_id")
  page.should have_selector("#team_conference_id")
  page.should have_selector("#team_division_id")
  page.should have_selector("#team_affiliation_id")
end