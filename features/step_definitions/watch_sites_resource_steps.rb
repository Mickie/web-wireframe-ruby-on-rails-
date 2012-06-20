
When /^I edit the watch site$/ do
  fill_in "Name",    with: "Irish watch"
  click_button "commit"
end

Then /^the changes to the watch site should be saved$/ do
  @edit_watch_site.reload
  @edit_watch_site.name.should == "Irish watch"
end

When /^I create a new watch site$/ do
  fill_in "Name",    with: @new_watch_site.name
  select @edit_team.name, from: 'watch_site[team_id]'
  select @edit_venue.name, from: 'watch_site[venue_id]'
  click_button "commit"
end

Then /^I should see the details of the new watch site$/ do
  page.should have_content(@new_watch_site.name)
end

Then /^I should be able to associate other resources with the watch site$/ do
  page.should have_selector("select#watch_site_team_id") 
  page.should have_selector("select#watch_site_venue_id")
end