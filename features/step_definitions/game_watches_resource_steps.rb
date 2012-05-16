
When /^I edit the game watch$/ do
  fill_in "Name",    with: "Killer Watch"
  click_button "commit"
  page.should have_content('Game watch was successfully updated')
end

Then /^the changes to the game watch should be saved$/ do
  @edit_game_watch.reload
  @edit_game_watch.name.should == "Killer Watch"
end

When /^I create a new game watch$/ do
  fill_in "Name",    with: @new_game_watch.name
  select @edit_event.name, from: 'game_watch[event_id]'
  select @edit_venue.name, from: 'game_watch[venue_id]'
  click_button "commit"
end

Given /^I have added two users$/ do 
  i = 0;
  begin
    FactoryGirl.create(:user, email:"user#{i}@foo.com")
    i += 1
  end while i < 2
end



Given /^I associate all venues with a game watch$/ do 
  @game_watch.venues = Venue.all
end

Then /^I should see the details of the new game watch$/ do
  page.should have_content(@new_game_watch.name)
end

Then /^I should be able to associate other resources with the game watch$/ do
  page.should have_selector("select#game_watch_event_id") 
  page.should have_selector("select#game_watch_venue_id")
  page.should have_selector("select#game_watch_creator_id")
end