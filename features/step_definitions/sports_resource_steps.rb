
When /^I edit the sport$/ do
  fill_in "Name",    with: "soccer"
  click_button "commit"
end

Then /^the changes to the sport should be saved$/ do
  @edit_sport.reload
  @edit_sport.name.should == "soccer"
end

When /^I edit the sport with duplicate name$/ do
  theExistingSport = Sport.last
  fill_in "Name", with: theExistingSport.name
  click_button "commit"
end

When /^I create a new sport$/ do
  fill_in "Name",    with: @new_sport.name
  click_button "commit"
end

Given /^I associate all leagues with a sport$/ do 
  @sport.leagues = League.all
end

Then /^the changes to the sport should not be saved$/ do
  Sport.where(name: @edit_sport.name ).count.should == 1
end

Then /^I should see the details of the new sport$/ do
  page.should have_content(@new_sport.name)
end

Then /^I should be able to associate a league with the sport$/ do
  page.should have_selector("#leagues")
end