Feature: Conferences Resource

	Scenario: Adding a conference requires admin access
		Given I visit the new conference page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Editing a conference requires admin access
		Given I visit the edit conference page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Seeing the list of conferences requires admin access
		Given I visit the conferences page
		Then I should be redirected to the new admin session page
			And I should see an alert flash
		
	Scenario: I can add a conference as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new conference page
			And I create a new conference
		Then I should see the details of the new conference
			And I should be able to edit it
	
	Scenario: I can edit a conference as an admin
		Given I sign in as admin
		When I visit the edit conference page
			And I edit the conference
		Then the changes to the conference should be saved
		
	Scenario: I can see all the conferences as an admin
		Given I sign in as admin
			And I have added 3 conferences
		When I visit the conferences page
		Then I should see 3 conferences

	Scenario: I can associate a sport with the conference
		Given I sign in as admin
			And I have added 2 sports
			And I have added 2 conferences
		When I visit the edit conference page
		Then I should be able to associate a sport with the conference