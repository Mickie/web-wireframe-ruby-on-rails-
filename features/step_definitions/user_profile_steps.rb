Then /^I should see a pick a sport prompt$/ do
  page.should have_selector("select#sport_picker")
end

When /^I pick a sport$/ do
  select @edit_team.sport.name, from: 'sport_picker'
end

Then /^I should see a pick a team prompt$/ do
  page.should have_selector("select#user_team_team_id")
end

When /^I pick a team$/ do
  select @edit_team.name, from: 'user_team_team_id'
  click_button "commit"   
end

Then /^I should see a list of upcoming games for my team$/ do
  page.should have_selector("select#event_id")
end

Given /^I login with a user who has picked a team$/ do
  @event.save
  @user.teams = [@event.home_team]
  @user.save

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "commit"  
end

When /^I pick an event$/ do
  select "#{@event.home_team.name} vs. #{@event.visiting_team.name}", from: 'event_id'
end
