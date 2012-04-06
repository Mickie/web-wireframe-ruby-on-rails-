Feature: Sports Resource

	Scenario: Adding a sport requires admin access
		Given I visit the new sport page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Editing a sport requires admin access
		Given I visit the edit sport page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Seeing the list of sports requires admin access
		Given I visit the sports page
		Then I should be redirected to the new admin session page
			And I should see an alert flash
		
	Scenario: I can add a sport as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new sport page
			And I create a new sport
		Then I should see the details of the new sport
			And I should be able to edit it
	
	Scenario: I can edit a sport as an admin
		Given I sign in as admin
		When I visit the edit sport page
			And I edit the sport
		Then the changes to the sport should be saved
		
	Scenario: I can see all the sports as an admin
		Given I sign in as admin
			And I have added 3 sports
		When I visit the sports page
		Then I should see 3 sports
