Before do
  @new_sport = FactoryGirl.build(:sport)
end

When /^I create a new sport$/ do
  fill_in "Name",    with: @new_sport.name
  click_button "commit"
end

Then /^I should be able to edit it$/ do
  page.should have_link('Edit')
end

When /^I edit the sport$/ do
  fill_in "Name",    with: "soccer"
  click_button "commit"
  page.should have_content('Sport was successfully updated')
end

Then /^the changes to the sport should be saved$/ do
  @edit_sport.reload
  @edit_sport.name.should == "soccer"
end

Then /^I should see the details of the new sport$/ do
  page.should have_content(@new_sport.name)
end

Given /^I have added (\d+) sports$/ do |theNumberOfSports|
  i = 0;
  begin
    FactoryGirl.create(:sport, name:"sport#{i}")
    i += 1
  end while i < theNumberOfSports.to_i
end

Then /^I should see (\d+) sports$/ do |theNumberOfSports|
  i = 0;
  begin
    page.should have_content("sport#{i}")
    i += 1
  end while i < theNumberOfSports.to_i
end