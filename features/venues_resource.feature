Feature: Venue Resource 

	Scenario: Adding a venue requires admin access
		Given I visit the new venue page
		Then I should be redirected to the new admin session page

	Scenario: Editing a venue requires admin access
		Given I visit the edit venue page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of venues requires admin access
		Given I visit the venues page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a venue as an admin and see the details as a user when complete
		Given I sign in as admin
			And I sign in as user
		When I visit the new venue page
			And I create a new venue
		Then I should see the details of the new venue
			And I should be able to edit it
	
	Scenario: I can edit a venue as an admin ans see result as user
		Given I sign in as admin
			And I sign in as user
		When I visit the edit venue page
			And I edit the venue
		Then the changes to the venue should be saved
		
	Scenario: I can see all the venues as an admin
		Given I sign in as admin
			And I have added 3 venues with names
		When I visit the venues page
		Then I should see 3 venues with names
		
	Scenario: The name of a venue should be unique
		Given I sign in as admin
			And I have added 2 venues with names
		When I visit the edit venue page
			And I edit the venue with duplicate name
		Then the changes to the venue should not be saved		

	Scenario: I can associate other resources with the venue
		Given I sign in as admin
			And I have added 2 locations with names
			And I have added 2 venue types with names
			And I have added 2 venues with names
		When I visit the edit venue page
		Then I should be able to associate other resources with the venue