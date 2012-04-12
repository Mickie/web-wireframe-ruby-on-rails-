
When /^I edit the affiliation$/ do
  fill_in "Name",    with: "University of Notre Dame"
  click_button "commit"
  page.should have_content('Affiliation was successfully updated')
end

When /^I create a new affiliation$/ do 
  fill_in "affiliation_name",    with: @new_affiliation.name

  fill_in "affiliation_social_info_attributes_twitter_name",    with: @new_affiliation.social_info.twitter_name
  fill_in "affiliation_social_info_attributes_facebook_page_url",    with: @new_affiliation.social_info.facebook_page_url
  fill_in "affiliation_social_info_attributes_web_url",    with: @new_affiliation.social_info.web_url

  fill_in "affiliation_location_attributes_name", with: @new_affiliation.location.name
  fill_in "affiliation_location_attributes_address1", with: @new_affiliation.location.address1
  fill_in "affiliation_location_attributes_address2", with: @new_affiliation.location.address2
  fill_in "affiliation_location_attributes_city", with: @new_affiliation.location.city
  fill_in "affiliation_location_attributes_postal_code", with: @new_affiliation.location.postal_code
  select @edit_affiliation.location.state.name, from: 'affiliation[location_attributes][state_id]'
  select @edit_affiliation.location.country.name, from: 'affiliation[location_attributes][country_id]'

  click_button "commit"
end


Then /^the changes to the affiliation should be saved$/ do
  @edit_affiliation.reload
  @edit_affiliation.name.should == "University of Notre Dame"
end

Then /^I should see the details of the new affiliation$/ do
  page.should have_content(@new_affiliation.name)
  page.should have_content(@new_affiliation.social_info.twitter_name)
  page.should have_content(@new_affiliation.social_info.facebook_page_url)
  page.should have_content(@new_affiliation.social_info.web_url)
end
