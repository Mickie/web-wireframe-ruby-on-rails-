
When /^I edit the event$/ do
  fill_in "Name",    with: "Superbowl"
  click_button "commit"
end

Then /^the changes to the event should be saved$/ do
  @edit_event.reload
  @edit_event.name.should == "Superbowl"
end

When /^I create a new event$/ do 
  fill_in "event_name",    with: @new_event.name
  select @edit_event.home_team.name, from: 'event[home_team_id]'
  select @edit_event.visiting_team.name, from: 'event[visiting_team_id]'

  fill_in "event_location_attributes_name", with: @new_event.location.name
  fill_in "event_location_attributes_address1", with: @new_event.location.address1
  fill_in "event_location_attributes_address2", with: @new_event.location.address2
  fill_in "event_location_attributes_city", with: @new_event.location.city
  fill_in "event_location_attributes_postal_code", with: @new_event.location.postal_code
  select @edit_event.location.state.name, from: 'event[location_attributes][state_id]'
  select @edit_event.location.country.name, from: 'event[location_attributes][country_id]'

  click_button "commit"
end

Then /^I should see the details of the new event$/ do
  page.should have_content(@edit_event.home_team.name)
  page.should have_content(@edit_event.visiting_team.name)
end


Then /^I should be able to associate other resources with the event$/ do
  page.should have_selector("#event_home_team_id")
  page.should have_selector("#event_visiting_team_id")
end