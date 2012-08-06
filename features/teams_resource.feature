Feature: Team Resource

	Scenario: Adding a team requires admin access
		Given I visit the new team page
		Then I should be redirected to the new admin session page

	Scenario: Editing a team requires admin access
		Given I visit the edit team page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of teams requires user access
		Given I visit the teams page
		Then I should be redirected to the new user session page
		
	Scenario: I can add a team as an admin and see the details as a user when complete
		Given I sign in as admin
			And I sign in as user
		When I visit the new team page
			And I create a new team
		Then I should see the details of the new team
	
	Scenario: I can edit a team as an admin
		Given I sign in as admin
			And I sign in as user
		When I visit the edit team page
			And I edit the team
		Then the changes to the team should be saved
		
	Scenario: I can see all the teams as a user
		Given I sign in as user 
			And I have added 3 teams with names
		When I visit the teams page
		Then I should see 3 teams with names

	Scenario: I can associate other resources with the team
		Given I sign in as admin
			And I have added 2 sports with names
			And I have added 2 leagues with names
			And I have added 2 divisions with names
			And I have added 2 conferences with names
			And I have added 2 locations with names
			And I have added 2 affiliations with names
			And I have added 2 teams with names
		When I visit the edit team page
		Then I should be able to associate other resources with the team