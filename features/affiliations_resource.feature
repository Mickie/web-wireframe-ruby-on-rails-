Feature: Affiliation Resource

	Scenario: Adding a affiliation requires admin access
		Given I visit the new affiliation page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Editing a affiliation requires admin access
		Given I visit the edit affiliation page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Seeing the list of affiliations requires admin access
		Given I visit the affiliations page
		Then I should be redirected to the new admin session page
			And I should see an alert flash
		
	Scenario: I can add a affiliation as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new affiliation page
			And I create a new affiliation
		Then I should see the details of the new affiliation
			And I should be able to edit it
	
	Scenario: I can edit a affiliation as an admin
		Given I sign in as admin
		When I visit the edit affiliation page
			And I edit the affiliation
		Then the changes to the affiliation should be saved
		
	Scenario: I can see all the affiliations as an admin
		Given I sign in as admin
			And I have added 3 affiliations
		When I visit the affiliations page
		Then I should see 3 affiliations
