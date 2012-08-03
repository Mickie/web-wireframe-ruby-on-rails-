Feature: User Settings

	@javascript
	Scenario: User can add a location
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the root page
		When I visit the user settings edit page
#		Then I should see an add a location link
#		When I click the add a location link
#		Then I should see a location form
#		When I fill in the location form
#		Then I should see my location data
