Feature: Tailgates Resource

	Scenario: Viewing a tailgate doesn't require user access
		Given I previously created a tailgate
			And I visit the tailgate page
		Then I should see see the details of the new tailgate

	Scenario: Adding a tailgate requires user access
		Given I visit the new tailgate page
		Then I should be redirected to the new user session page

	Scenario: Editing a tailgate requires at least user access
		Given I visit the edit tailgate page
		Then I should be redirected to the new user session page

	Scenario: Seeing the list of tailgates doesn't require user access
		Given I have added 3 tailgates
		When I visit the tailgates page
		Then I should see 3 tailgates 
	
	@javascript	
	Scenario: I can add a tailgate as a user and see the details when complete
		Given I sign in as user
		When I visit the new tailgate page
		Then I should see a pick a league prompt
		When I pick a league 
			And I pick a team for my tailgate
			And I finish creating a new tailgate
		Then I should see the details of the new tailgate
	
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
		
	Scenario: I can't add a post to a tailgate without logging in
		Given I previously created a tailgate
		When I visit the tailgate page
			And I add a post
		Then I should be redirected to the new user session page
			
	Scenario: I can add a post to a tailgate as a user
		Given I sign in as user
			And I previously created a tailgate
		When I visit the tailgate page
			And I add a post
		Then I see the new post on the tailgate page
		
	Scenario: I can't add a comment to a tailgate post without logging in	
		Given I previously created a tailgate
			And I previously added a post
		When I visit the tailgate page
			And I comment on the post
		Then I should be redirected to the new user session page
	
	Scenario: I can add a comment to a tailgate post as a user
		Given I sign in as user	
			And I previously created a tailgate
			And I previously added a post
		When I visit the tailgate page
			And I comment on the post
		Then I should see the comment on the post on the tailgate page	
	