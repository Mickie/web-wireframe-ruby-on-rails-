
When /^I edit the division$/ do
  fill_in "Name",    with: "MLS"
  click_button "commit"
end

When /^I create a new division$/ do 
  fill_in "Name",    with: @new_division.name
  select @edit_league.name, from: 'division[league_id]'
  click_button "commit"
end


Then /^the changes to the division should be saved$/ do
  @edit_division.reload
  @edit_division.name.should == "MLS"
end

Then /^I should see the details of the new division$/ do
  page.should have_content(@new_division.name)
end

Then /^I should be able to associate a league with the division$/ do
  page.should have_selector("#division_league_id")
end