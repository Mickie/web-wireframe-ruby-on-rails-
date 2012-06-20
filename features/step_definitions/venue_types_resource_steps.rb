
When /^I edit the venue type$/ do
  fill_in "Name",    with: "Sport Bar"
  click_button "commit"
end

Then /^the changes to the venue type should be saved$/ do
  @edit_venue_type.reload
  @edit_venue_type.name.should == "Sport Bar"
end

When /^I edit the venue type with duplicate name$/ do
  theExistingVenueType = VenueType.last
  fill_in "Name", with: theExistingVenueType.name
  click_button "commit"
end

When /^I create a new venue type$/ do
  fill_in "Name",    with: @new_venue_type.name
  click_button "commit"
end

Given /^I associate all venues with a venue type$/ do 
  @venue_type.venues = Venue.all
end

Then /^the changes to the venue type should not be saved$/ do
  VenueType.find_by_name("Sport Bar").should be_nil
end

Then /^I should see the details of the new venue type$/ do
  page.should have_content(@new_venue_type.name)
end

Then /^I should be able to associate a venue with the venue type$/ do
  page.should have_selector("#venues")
end