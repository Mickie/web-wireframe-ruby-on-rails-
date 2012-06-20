Feature: Watch site Resource

	Scenario: Adding a watch site requires admin access
		Given I visit the new watch site page
		Then I should be redirected to the new admin session page

	Scenario: Editing a watch site requires admin access
		Given I visit the edit watch site page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of watch sitees requires admin access
		Given I visit the watch sites page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a watch site as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new watch site page
			And I create a new watch site
		Then I should see the details of the new watch site
			And I should be able to edit it
	
	Scenario: I can edit a watch site as an admin
		Given I sign in as admin
		When I visit the edit watch site page
			And I edit the watch site
		Then the changes to the watch site should be saved
		
	Scenario: I can see all the watch sites as an admin
		Given I sign in as admin
			And I have added 3 watch sites
		When I visit the watch sites page
		Then I should see 3 watch sites

	Scenario: I can associate other resources with the watch site
		Given I sign in as admin
			And I have added 2 venues
			And I have added 2 teams
		When I visit the edit watch site page
		Then I should be able to associate other resources with the watch site