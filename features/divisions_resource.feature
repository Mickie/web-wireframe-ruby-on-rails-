Feature: Divisions Resource

	Scenario: Adding a division requires admin access
		Given I visit the new division page
		Then I should be redirected to the new admin session page

	Scenario: Editing a division requires admin access
		Given I visit the edit division page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of divisions requires admin access
		Given I visit the divisions page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a division as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new division page
			And I create a new division
		Then I should see the details of the new division
			And I should be able to edit it
	
	Scenario: I can edit a division as an admin
		Given I sign in as admin
		When I visit the edit division page
			And I edit the division
		Then the changes to the division should be saved
		
	Scenario: I can see all the divisions as an admin
		Given I sign in as admin
			And I have added 3 divisions with names
		When I visit the divisions page
		Then I should see 3 divisions with names

	Scenario: I can associate a league with the division
		Given I sign in as admin
			And I have added 2 leagues with names
			And I have added 2 divisions with names
		When I visit the edit division page
		Then I should be able to associate a league with the division