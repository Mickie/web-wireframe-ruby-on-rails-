Given /^I previously created a tailgate$/ do 
  @user.save
  @user.reload 
  @edit_tailgate.user = @user
  @edit_tailgate.save

  @tailgate.user = @user
  @tailgate.save
end

Then /^I should see see the details of the new tailgate$/ do
  page.should have_content(@tailgate.name)
end

When /^I create a new tailgate$/ do
  fill_in "Name", with: @new_tailgate.name
  select @edit_team.name, from: 'tailgate[team_id]'
  click_button "commit"  
end

Then /^I should see the details of the new tailgate$/ do
  page.should have_content(@new_tailgate.name)
end

When /^I edit the tailgate$/ do
  fill_in "Name", with: "Dave's killer tailgate"
  select @edit_team.name, from: 'tailgate[team_id]'
  click_button "commit"  
end

Then /^the changes to the tailgate should be saved$/ do
  @edit_tailgate.reload
  @edit_tailgate.name.should == "Dave's killer tailgate"
end

Then /^I should be able to associate a team with the tailgate$/ do
  page.should have_selector("#tailgate_team_id")
end