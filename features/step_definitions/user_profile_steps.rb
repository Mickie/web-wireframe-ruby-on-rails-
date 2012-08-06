Then /^I should see a pick a league prompt$/ do
  page.should have_selector("select#league_picker")
end

When /^I pick a league$/ do
  select @team.league.name, from: 'league_picker' 
end

Then /^I should see a pick a team prompt$/ do
  page.should have_selector("select#user_team_team_id")
end

When /^I pick a team$/ do
  select @team.name, from: 'user_team_team_id'
  click_button "commit"   
end

Then /^I should see my team link$/ do
  page.should have_link(@team.name)
end

Given /^I login with a user who has picked a team$/ do
  @team.save
  @user.teams = [@team]
  @user.save

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "commit"  
end

Then /^I should see an add a team link$/ do
  @team.save
  page.should have_link("Add Team")
end

When /^I click the add a team link$/ do
  click_link "Add Team"
end

When /^I click on a team link$/ do 
  page.should have_link(@team.name)
  click_link @team.name
end

When /^I click on the create tailgate button$/ do
  click_link "Start Your Own Fanzone" 
end

Then /^I should see an add a location link$/ do
  page.should have_link("Add Location")
end

When /^I click the add a location link$/ do
  click_link "Add Location"
end

Then /^I should see a location form$/ do
  page.should have_selector("#user_location_location_query")
end

When /^I fill in the location form$/ do
  fill_in "user_location_location_query", with: "Space Needle"

  click_button "commit"
end

Then /^I should see my location data$/ do  
  find(".saved_locations").should have_content("Space Needle")
end

Then /^I should see team data$/ do
  page.should have_content(@team.location.address1)
end
