Feature: Leagues Resource

	Scenario: Adding a league requires admin access
		Given I visit the new league page
		Then I should be redirected to the new admin session page

	Scenario: Editing a league requires admin access
		Given I visit the edit league page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of leagues requires admin access
		Given I visit the leagues page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a league as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new league page
			And I create a new league
		Then I should see the details of the new league
			And I should be able to edit it
	
	Scenario: I can edit a league as an admin
		Given I sign in as admin
		When I visit the edit league page
			And I edit the league
		Then the changes to the league should be saved
		
	Scenario: I can see all the leagues as an admin
		Given I sign in as admin
			And I have added 3 leagues
		When I visit the leagues page
		Then I should see 3 leagues

	Scenario: I can associate a sport with the league
		Given I sign in as admin
			And I have added 2 sports
			And I have added 2 leagues
		When I visit the edit league page
		Then I should be able to associate a sport with the league