
When /^I edit the venue$/ do
  @edit_venue.foursquare_id = '12345'
  @edit_venue.save
  
  fill_in "Name",    with: "Pumphouse"
  click_button "commit"
end

When /^I create a new venue$/ do 
  theStubClient = double(Foursquare2::Client)
  Foursquare2::Client.stub(:new).and_return(theStubClient)
  theVenuesResponse = {
    venues: [ Hashie::Mash.new(
      {
        id: "4af34dacf964a52073ec21e3",
        name: "Bailey's Pub & Grille"
      })
    ]
  }
  
  theStubClient.stub(:search_venues).and_return(theVenuesResponse)
  
  fill_in "venue_name",    with: @new_venue.name
  select @edit_venue_type.name, from: 'venue[venue_type_id]'

  fill_in "venue_social_info_attributes_twitter_name",    with: @new_venue.social_info.twitter_name
  fill_in "venue_social_info_attributes_facebook_page_url",    with: @new_venue.social_info.facebook_page_url
  fill_in "venue_social_info_attributes_web_url",    with: @new_venue.social_info.web_url


  fill_in "venue_location_attributes_name", with: @new_venue.location.name
  fill_in "venue_location_attributes_address1", with: @new_venue.location.address1
  fill_in "venue_location_attributes_address2", with: @new_venue.location.address2
  fill_in "venue_location_attributes_city", with: @new_venue.location.city
  fill_in "venue_location_attributes_postal_code", with: @new_venue.location.postal_code
  select @edit_venue.location.state.name, from: 'venue[location_attributes][state_id]'
  select @edit_venue.location.country.name, from: 'venue[location_attributes][country_id]'

  click_button "commit"
end


Then /^the changes to the venue should be saved$/ do
  @edit_venue.reload
  @edit_venue.name.should == "Pumphouse"
end

Then /^I should see the details of the new venue$/ do
  page.should have_content(@new_venue.name)
  page.should have_content(@new_venue.social_info.twitter_name)
  page.should have_content(@new_venue.social_info.facebook_page_url)
  page.should have_content(@new_venue.social_info.web_url)
end

When /^I edit the venue with duplicate name$/ do
  theExistingVenue = Venue.last
  fill_in "Name", with: theExistingVenue.name
  click_button "commit"
end

Then /^the changes to the venue should not be saved$/ do
  Venue.where(name: @edit_venue.name ).count.should == 1
end


Then /^I should be able to associate other resources with the venue$/ do
  page.should have_selector("#venue_venue_type_id")
end