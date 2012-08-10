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

Then /^I should see an add a team link$/ do
  @team.save
  page.should have_link("Add Team")
end

When /^I click the add a team link$/ do
  click_link "Add Team"
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

  click_button "Add"
end

Then /^I should see my location data$/ do  
  find(".saved_locations").should have_content("Space Needle")
end

Then /^I should see my team data$/ do
  find(".saved_teams").should have_content(@team.name)
end


Then /^I should see a description textarea$/ do
  page.should have_selector("textarea#user_description")
end

When /^I submit a new description$/ do
  fill_in "user_description", with: "description"

  click_button "Save"
end

Then /^I should see the new description$/ do
  find("#userShow").should have_content("description")
end