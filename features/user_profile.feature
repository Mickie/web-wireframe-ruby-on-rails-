Feature: User Profile

	@javascript
	Scenario: First time user should get initial queries
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the user page
			And I should see a pick a sport prompt
		When I pick a sport
		Then I should see a pick a team prompt
		When I pick a team
		Then I should see a list of upcoming games for my team
		
	Scenario: Returning user should see upcoming games
		Given I login with a user who has picked a team
		Then I should be on the user page
			And I should see a list of upcoming games for my team
			
	@javascript		
	Scenario: Picking a game should take you to the game show page
		Given I login with a user who has picked a team
		When I pick an event
		Then I should be on the event page		