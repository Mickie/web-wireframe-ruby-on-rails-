
When /^I edit the quick tweet$/ do
  fill_in "quick_tweet_name",    with: "Nice!"
  fill_in "quick_tweet_tweet", with: "that was a sweet play"
  click_button "commit"
end

When /^I create a new quick tweet$/ do 
  fill_in "Name",    with: @new_quick_tweet.name
  fill_in "Tweet",    with: @new_quick_tweet.tweet
  select @edit_sport.name, from: 'quick_tweet[sport_id]'
  click_button "commit"
end


Then /^the changes to the quick tweet should be saved$/ do
  @edit_quick_tweet.reload
  @edit_quick_tweet.name.should == "Nice!"
  @edit_quick_tweet.tweet.should == "that was a sweet play"
end

Then /^I should see the details of the new quick tweet/ do
  page.should have_content(@new_quick_tweet.name)
end

Then /^I should be able to associate a sport with the quick tweet$/ do
  page.should have_selector("#quick_tweet_sport_id")
end