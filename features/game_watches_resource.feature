Feature: Game Watch Resource

	Scenario: Adding a game watch requires admin access
		Given I visit the new game watch page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Editing a game watch requires admin access
		Given I visit the edit game watch page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Seeing the list of game watches requires admin access
		Given I visit the game watches page
		Then I should be redirected to the new admin session page
			And I should see an alert flash
		
	Scenario: I can add a game watch as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new game watch page
			And I create a new game watch
		Then I should see the details of the new game watch
			And I should be able to edit it
	
	Scenario: I can edit a game watch as an admin
		Given I sign in as admin
		When I visit the edit game watch page
			And I edit the game watch
		Then the changes to the game watch should be saved
		
	Scenario: I can see all the game watches as an admin
		Given I sign in as admin
			And I have added 3 game watchs
		When I visit the game watches page
		Then I should see 3 game watchs	

	Scenario: I can associate other resources with the game watch
		Given I sign in as admin
			And I have added two users
			And I have added 2 venues
			And I have added 2 events
		When I visit the edit game watch page
		Then I should be able to associate other resources with the game watch