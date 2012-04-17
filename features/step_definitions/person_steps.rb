
When /^I edit the person$/ do
  fill_in "person_first_name",    with: "howdy"
  fill_in "person_last_name",    with: "doody"
  click_button "commit"
  page.should have_content('Person was successfully updated')
end

When /^I create a new person$/ do 
  fill_in "person_first_name",    with: @new_person.first_name
  fill_in "person_last_name",    with: @new_person.last_name
  click_button "commit"
end

Then /^the changes to the person should be saved$/ do
  @edit_person.reload
  @edit_person.first_name.should == "howdy"
  @edit_person.last_name.should == "doody"
end

Then /^I should see the details of the new person$/ do
  page.should have_content(@new_person.first_name)
  page.should have_content(@new_person.last_name)
end

Then /^I should be able to associate a team with a person$/ do
 page.should have_selector("#person_team_id")
end

Given /^I have added (\d+) people$/ do |aNumberOfObjects|
  i = 0;
  begin
    FactoryGirl.create(eval(":person"), first_name:"person#{i}")
    i += 1
  end while i < aNumberOfObjects.to_i
end

Then /^I should see (\d+) people$/ do |aNumberOfObjects|
  i = 0;
  begin
    page.should have_content("person#{i}")
    i += 1
  end while i < aNumberOfObjects.to_i
end