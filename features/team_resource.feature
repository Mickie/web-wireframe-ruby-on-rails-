Feature: Team Resource

	Scenario: Adding a team requires admin access
		Given I visit the new team page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Editing a team requires admin access
		Given I visit the edit team page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Seeing the list of teams requires user access
		Given I visit the teams page
		Then I should be redirected to the new user session page
			And I should see an alert flash
		
	Scenario: I can add a team as an admin and see the details as a user when complete
		Given I sign in as admin
			And I sign in as user
		When I visit the new team page
			And I create a new team
		Then I should see the details of the new team
			And I should be able to edit it
	
	Scenario: I can edit a team as an admin
		Given I sign in as admin
			And I sign in as user
		When I visit the edit team page
			And I edit the team
		Then the changes to the team should be saved
		
	Scenario: I can see all the teams as a user
		Given I sign in as user 
			And I have added 3 teams
		When I visit the teams page
		Then I should see 3 teams

	Scenario: I can associate other resources with the team
		Given I sign in as admin
			And I have added 2 sports
			And I have added 2 leagues
			And I have added 2 divisions
			And I have added 2 conferences
			And I have added 2 locations
			And I have added 2 affiliations
			And I have added 2 teams
		When I visit the edit team page
		Then I should be able to associate other resources with the team