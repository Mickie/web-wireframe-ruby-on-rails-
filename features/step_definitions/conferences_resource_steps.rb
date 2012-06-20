
When /^I edit the conference$/ do
  fill_in "Name",    with: "MLS"
  click_button "commit"
end

When /^I create a new conference$/ do 
  fill_in "Name",    with: @new_conference.name
  select @edit_league.name, from: 'conference[league_id]'
  click_button "commit"
end


Then /^the changes to the conference should be saved$/ do
  @edit_conference.reload
  @edit_conference.name.should == "MLS"
end

Then /^I should see the details of the new conference$/ do
  page.should have_content(@new_conference.name)
end

Then /^I should be able to associate a sport with the conference$/ do
  page.should have_selector("#conference_league_id")
end