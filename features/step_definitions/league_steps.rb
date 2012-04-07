
When /^I edit the league$/ do
  fill_in "Name",    with: "MLS"
  click_button "commit"
  page.should have_content('League was successfully updated')
end

When /^I create a new league$/ do 
  fill_in "Name",    with: @new_league.name
  select @edit_sport.name, from: 'league[sport_id]'
  click_button "commit"
end


Then /^the changes to the league should be saved$/ do
  @edit_league.reload
  @edit_league.name.should == "MLS"
end

Then /^I should see the details of the new league$/ do
  page.should have_content(@new_league.name)
end

Then /^I should be able to associate a sport with the league$/ do
  page.should have_selector("#league_sport_id")
end