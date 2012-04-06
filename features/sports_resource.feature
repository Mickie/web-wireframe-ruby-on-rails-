Feature: Sports Resource

	Scenario: Adding a sport requires admin access
		Given I visit the new sport page
		Then I should be redirected to the new admin session page
			And I should see an alert flash
		
	Scenario: I can add a sport as an admin
		Given I sign in as admin
		When I visit the new sport page
			And I create a new sport
		Then I should be able to edit it