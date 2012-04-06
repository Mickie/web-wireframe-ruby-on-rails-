Before do
  @user = FactoryGirl.build(:user)
  @admin = FactoryGirl.build(:admin)
  @edit_sport = FactoryGirl.create(:sport)
end


Given /^I visit the (.*) page$/ do |page_name|
  object = instance_variable_get("@#{page_name.downcase.gsub(' ','_')}")
  visit send("#{page_name.downcase.gsub(' ','_')}_path", object)
end

Given /^I sign in as (.*)$/ do |account_type|
  object = instance_variable_get("@#{account_type.downcase.gsub(' ','_')}")
  object.save
  visit send("new_#{account_type.downcase.gsub(' ','_')}_session_path")
  fill_in "Email",    with: object.email
  fill_in "Password", with: object.password
  click_button "commit"
  page.should have_content('Signed in successfully')
end

Then /^I should be on the (.*) page$/ do |page_name|
  object = instance_variable_get("@#{page_name.downcase.gsub(' ','_')}")
  page.current_path.should == send("#{page_name.downcase.gsub(' ','_')}_path", object)
  page.status_code.should == 200
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  step %Q(I should be on the #{page_name} page)
end

Then /^I should see an alert flash$/ do
  page.should have_selector(".alert-alert")
end