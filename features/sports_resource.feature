Feature: Sports Resource

	Scenario: Adding a sport requires admin access
		Given I visit the new sport page
		Then I should be redirected to the new admin session page
			And I should see an alert flash
		