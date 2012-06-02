
Before do
  
  @user = FactoryGirl.build(:user)
  @admin = FactoryGirl.build(:admin)
  @connect_twitter_user = @user
  
  @sport = FactoryGirl.create(:sport)
  @league = FactoryGirl.create(:league)
  @conference = FactoryGirl.create(:conference)
  @division = FactoryGirl.create(:division)
  @team = FactoryGirl.create(:team)
  @affiliation = FactoryGirl.create(:affiliation)
  @venue_type = FactoryGirl.create(:venue_type)
  @venue = FactoryGirl.create(:venue)
  @event = FactoryGirl.create(:event)
  @game_watch = FactoryGirl.create(:game_watch)
  @watch_site = FactoryGirl.create(:watch_site)
  @person = FactoryGirl.create(:person)
  @quick_tweet = FactoryGirl.create(:quick_tweet)
  @tailgate = FactoryGirl.create(:tailgate)
  @post = FactoryGirl.create(:post, tailgate:@tailgate)
  
  @new_sport = FactoryGirl.build(:sport)
  @new_league = FactoryGirl.build(:league)
  @new_conference = FactoryGirl.build(:conference)
  @new_division = FactoryGirl.build(:division)
  @new_team = FactoryGirl.build(:team)
  @new_affiliation = FactoryGirl.build(:affiliation)
  @new_venue_type = FactoryGirl.build(:venue_type)
  @new_venue = FactoryGirl.build(:venue)
  @new_event = FactoryGirl.build(:event)
  @new_game_watch = FactoryGirl.build(:game_watch)
  @new_watch_site = FactoryGirl.build(:watch_site)
  @new_person = FactoryGirl.build(:person)
  @new_quick_tweet = FactoryGirl.build(:quick_tweet)
  @new_tailgate = FactoryGirl.build(:tailgate)
  @new_post = FactoryGirl.build(:post, tailgate:@tailgate)
  @new_comment = FactoryGirl.build(:comment)
  
  @edit_sport = FactoryGirl.create(:sport)
  @edit_league = FactoryGirl.create(:league)
  @edit_conference = FactoryGirl.create(:conference)
  @edit_division = FactoryGirl.create(:division)
  @edit_team = FactoryGirl.create(:team)
  @edit_affiliation = FactoryGirl.create(:affiliation)
  @edit_venue_type = FactoryGirl.create(:venue_type)
  @edit_venue = FactoryGirl.create(:venue)
  @edit_event = FactoryGirl.create(:event)
  @edit_game_watch = FactoryGirl.create(:game_watch)
  @edit_watch_site = FactoryGirl.create(:watch_site)
  @edit_person = FactoryGirl.create(:person)
  @edit_quick_tweet = FactoryGirl.create(:quick_tweet)
  @edit_tailgate = FactoryGirl.create(:tailgate)
  @edit_post = FactoryGirl.create(:post, tailgate:@edit_tailgate)

end


Given /^I visit the (.*) page$/ do |aPageName|
  object = instance_variable_get("@#{aPageName.downcase.gsub(' ','_')}")
  visit send("#{aPageName.downcase.gsub(' ','_')}_path", object)
end

Given /^I visit the (.*) nested resource$/ do |aNestedResource|
  theResources = aNestedResource.split(' ')
  theParent = instance_variable_get("@#{theResources[theResources.length-2].downcase}")
  
  thePrefix = ""
  if (theResources.length > 2)
    thePrefix = theResources[0] + "_"
  end
    
  theNestedResource = instance_variable_get("@#{thePrefix}#{theResources[theResources.length-1].downcase}")
  
  visit send("#{aNestedResource.downcase.gsub(' ','_')}_path", theParent, theNestedResource)
end


Given /^I sign in as (.*)$/ do |anAccountType|
  object = instance_variable_get("@#{anAccountType.downcase.gsub(' ','_')}")
  object.save
  visit send("new_#{anAccountType.downcase.gsub(' ','_')}_session_path")
  fill_in "Email",    with: object.email
  fill_in "Password", with: object.password
  click_button "commit"
  page.should have_content('Signed in successfully')
end

Then /^I should be able to edit it$/ do
  page.should have_link('Edit')
end

Then /^I should be on the (.*) page$/ do |aPageName|
  object = instance_variable_get("@#{aPageName.downcase.gsub(' ','_')}")
  page.current_path.should == send("#{aPageName.downcase.gsub(' ','_')}_path", object)
end

Then /^I should be redirected to the (.*) page$/ do |aPageName|
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  step %Q(I should be on the #{aPageName} page)
end

Then /^I should see an alert flash$/ do
  page.should have_selector(".alert-alert")
end

Given /^I have added (\d+) ([\w ]+)s$/ do |aNumberOfObjects, anObjectType|
  i = 0;
  theObjectType = anObjectType.downcase.gsub(' ', '_')
  begin
    FactoryGirl.create(eval(":#{theObjectType}"), name:"#{anObjectType}#{i}")
    i += 1
  end while i < aNumberOfObjects.to_i
end

Then /^I should see (\d+) ([\w ]+)s$/ do |aNumberOfObjects, anObjectType|
  i = 0;
  begin
    page.should have_content("#{anObjectType}#{i}")
    i += 1
  end while i < aNumberOfObjects.to_i
end