Feature: User Profile

	@javascript
	Scenario: User can add a location
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the root page
		When I visit the user page
		Then I should see an add a location link
		When I click the add a location link
		Then I should see a location form
		When I fill in the location form
		Then I should see my location data
		
	Scenario: Returning user should see their team
		Given I login with a user who has picked a team
		Then I should be on the root page
		When I visit the user page
		Then I should see my team link
	
	@javascript		
	Scenario: Clicking a team link should show the team data in right pane
		Given I login with a user who has picked a team
			And I visit the user page
		When I click on a team link
		Then I should see team data	
		
	Scenario: Clicking the create tailgate button should take me to the new tailgate page
		Given I sign in as user
			And I visit the user page
		When I click on the create tailgate button
		Then I should be on the new tailgate page			