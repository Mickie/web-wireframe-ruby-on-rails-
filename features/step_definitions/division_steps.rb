
When /^I edit the division$/ do
  fill_in "Name",    with: "MLS"
  click_button "commit"
  page.should have_content('Division was successfully updated')
end

When /^I create a new division$/ do 
  fill_in "Name",    with: @new_division.name
  select @edit_conference.name, from: 'division[conference_id]'
  click_button "commit"
end


Then /^the changes to the division should be saved$/ do
  @edit_division.reload
  @edit_division.name.should == "MLS"
end

Then /^I should see the details of the new division$/ do
  page.should have_content(@new_division.name)
end

Then /^I should be able to associate a sport with the division$/ do
  page.should have_selector("#division_conference_id")
end