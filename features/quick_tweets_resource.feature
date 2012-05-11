Feature: QuickTweets Resource

	Scenario: Adding a quick tweet requires admin access
		Given I visit the new quick tweet page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Editing a quick tweet requires admin access
		Given I visit the edit quick tweet page
		Then I should be redirected to the new admin session page
			And I should see an alert flash

	Scenario: Seeing the list of quick tweets requires user access
		Given I visit the quick tweets page
		Then I should be redirected to the new user session page
			And I should see an alert flash
		
	Scenario: I can add a quick tweet as an admin and see the details when complete
		Given I sign in as admin
			And I sign in as user
		When I visit the new quick tweet page
			And I create a new quick tweet
		Then I should see the details of the new quick tweet
			And I should be able to edit it
	
	Scenario: I can edit a quick tweet as an admin
		Given I sign in as admin
			And I sign in as user
		When I visit the edit quick tweet page
			And I edit the quick tweet
		Then the changes to the quick tweet should be saved
		
	Scenario: I can see all the quick tweets as a user
		Given I sign in as user
			And I have added 3 quick tweets
		When I visit the quick tweets page
		Then I should see 3 quick tweets

	Scenario: I can associate a sport with the quick tweet
		Given I sign in as admin
			And I have added 2 sports
			And I have added 2 quick tweets
		When I visit the edit quick tweet page
		Then I should be able to associate a sport with the quick tweet