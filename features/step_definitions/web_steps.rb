Given /^I visit the (.*) page$/ do |page_name|
  object = instance_variable_get("@#{page_name.downcase.gsub(' ','_')}")
  visit send("#{page_name.downcase.gsub(' ','_')}_path", object)
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