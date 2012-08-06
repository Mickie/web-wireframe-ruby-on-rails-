Feature: people Resource

	Scenario: Adding a person requires admin access
		Given I visit the new person page
		Then I should be redirected to the new admin session page

	Scenario: Editing a person requires admin access
		Given I visit the edit person page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of people requires admin access
		Given I visit the people page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a person as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new person page
			And I create a new person
		Then I should see the details of the new person
			And I should be able to edit it
	
	Scenario: I can edit a person as an admin
		Given I sign in as admin
		When I visit the edit person page
			And I edit the person
		Then the changes to the person should be saved
		
	Scenario: I can see all the people as an admin
		Given I sign in as admin
			And I have added 3 people with names
		When I visit the people page
		Then I should see 3 people with names

	Scenario: I can associate a sport with the person
		Given I sign in as admin
			And I have added 2 sports with names
			And I have added 2 people with names
		When I visit the edit person page
		Then I should be able to associate a team with a person