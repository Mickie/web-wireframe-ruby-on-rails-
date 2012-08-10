Feature: User Settings

	@javascript
	Scenario: User can add a location and a team
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the root page
		When I visit the user settings edit page
		Then I should see an add a location link
			And I should see an add a team link
		When I click the add a location link
		Then I should see a location form
		When I fill in the location form
		Then I should see my location data
		When I click the add a team link
		Then I should see a pick a league prompt
		When I pick a league
		Then I should see a pick a team prompt
		When I pick a team
		Then I should see my team data
		
	Scenario: User can update their description
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the root page
		When I visit the user settings edit page
		Then I should see a description textarea
		When I submit a new description
		Then I should be on the user page
			And I should see the new description	

