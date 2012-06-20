Feature: Event Resource

	Scenario: Adding a event requires admin access
		Given I visit the new event page
		Then I should be redirected to the new admin session page

	Scenario: Editing a event requires admin access
		Given I visit the edit event page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of events requires user access
		Given I visit the events page
		Then I should be redirected to the new user session page
		
	Scenario: I can add a event as an admin and see the details as a user when complete
		Given I sign in as admin
			And I sign in as user
		When I visit the new event page
			And I create a new event
		Then I should see the details of the new event
	
	Scenario: I can edit a event as an admin
		Given I sign in as admin
			And I sign in as user
		When I visit the edit event page
			And I edit the event
		Then the changes to the event should be saved
		
	Scenario: I can see all the events as a user
		Given I sign in as user
			And I have added 3 events
		When I visit the events page
		Then I should see 3 events	

	Scenario: I can associate other resources with the event
		Given I sign in as admin
			And I have added 2 locations
			And I have added 2 teams
			And I have added 2 events
		When I visit the edit event page
		Then I should be able to associate other resources with the event