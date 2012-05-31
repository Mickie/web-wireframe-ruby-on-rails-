Feature: User Profile

	@javascript
	Scenario: User can add a team
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the user page
			And I should see an add a team link
		When I click the add a team link
		Then I should see a pick a league prompt
		When I pick a league 
		Then I should see a pick a team prompt
		When I pick a team
		Then I should see my team link

	@javascript
	Scenario: User can add a location
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the user page
			And I should see an add a location link
		When I click the add a location link
		Then I should see a location form
		When I fill in the location form
		Then I should see my location data
		
	Scenario: Returning user should see their team
		Given I login with a user who has picked a team
		Then I should be on the user page
			And I should see my team link
			
	Scenario: Clicking a team link should take me to the team page
		Given I login with a user who has picked a team
		When I click on a team link
		Then I should be on the team page	
		
	Scenario: Clicking the create tailgate button should take me to the new tailgate page
		Given I sign in as user
		When I click on the create tailgate button
		Then I should be on the new tailgate page			