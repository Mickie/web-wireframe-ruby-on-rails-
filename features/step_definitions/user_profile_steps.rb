Given /^I login with a user who has picked a team$/ do
  @team.save
  @user.teams = [@team]
  @user.save

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "commit"  
end

Then /^I should see my team$/ do
  page.should have_content(@team.name)
end
