Then /^I should see a pick a sport prompt$/ do
  page.should have_selector("select#sport_picker")
end

When /^I pick a sport$/ do
  select @team.sport.name, from: 'sport_picker'
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
  click_link @team.name
end