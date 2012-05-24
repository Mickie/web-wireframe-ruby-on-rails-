Feature: Tailgates Resource

	Scenario: Viewing a tailgate doesn't require user access
		Given I previously created a tailgate
			And I visit the tailgate page
		Then I should see see the details of the new tailgate

	Scenario: Adding a tailgate requires user access
		Given I visit the new tailgate page
		Then I should be redirected to the new user session page
			And I should see an alert flash

	Scenario: Editing a tailgate requires at least user access
		Given I visit the edit tailgate page
		Then I should be redirected to the new user session page
			And I should see an alert flash

	Scenario: Seeing the list of tailgates doesn't require user access
		Given I have added 3 tailgates
		When I visit the tailgates page
		Then I should see 3 tailgates 
		
	Scenario: I can add a tailgate as a user and see the details when complete
		Given I sign in as user
		When I visit the new tailgate page
			And I create a new tailgate
		Then I should see the details of the new tailgate
			And I should be able to edit it
	
	Scenario: I can edit a tailgate as the user who created it
		Given I previously created a tailgate
			And I sign in as user
		When I visit the edit tailgate page
			And I edit the tailgate
		Then the changes to the tailgate should be saved

	Scenario: I can't edit a tailgate as a user who didn't created the tailgate
		Given I sign in as user
		When I visit the edit tailgate page
		Then I should be redirected to the user page
			And I should see an alert flash

	Scenario: I can see all the tailgates as a user
		Given I sign in as user
			And I have added 3 tailgates
		When I visit the tailgates page
		Then I should see 3 tailgates

	Scenario: I can associate a team with the tailgate 
		Given I previously created a tailgate
			And I have added 2 teams
			And I sign in as user
		When I visit the edit tailgate page
		Then I should be able to associate a team with the tailgate
		
		