Before do
  @user = FactoryGirl.build(:user)
  @admin = FactoryGirl.build(:admin)
  @sport = FactoryGirl.create(:sport)
  @new_sport = FactoryGirl.build(:sport)
  @new_league = FactoryGirl.build(:league)
  @edit_sport = FactoryGirl.create(:sport)
  @edit_league = FactoryGirl.create(:league)
end


Given /^I visit the (.*) page$/ do |aPageName|
  object = instance_variable_get("@#{aPageName.downcase.gsub(' ','_')}")
  visit send("#{aPageName.downcase.gsub(' ','_')}_path", object)
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
  page.status_code.should == 200
end

Then /^I should be redirected to the (.*) page$/ do |aPageName|
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  step %Q(I should be on the #{aPageName} page)
end

Then /^I should see an alert flash$/ do
  page.should have_selector(".alert-alert")
end

Given /^I have added (\d+) (\w+)s$/ do |aNumberOfObjects, anObjectType|
  i = 0;
  begin
    FactoryGirl.create(eval(":#{anObjectType}"), name:"#{anObjectType}#{i}")
    i += 1
  end while i < aNumberOfObjects.to_i
end

Then /^I should see (\d+) (\w+)s$/ do |aNumberOfObjects, anObjectType|
  i = 0;
  begin
    page.should have_content("#{anObjectType}#{i}")
    i += 1
  end while i < aNumberOfObjects.to_i
end