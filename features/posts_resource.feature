Feature: Posts Resource 

	Scenario: Viewing a post doesn't require user access
		Given I previously created a post
			And I visit the tailgate post nested resource
		Then I should see the details of the post

	Scenario: Adding a post requires user access 
		Given I visit the new tailgate post nested resource
		Then I should be redirected to the new user session page
			And I should see an alert flash

	Scenario: Editing a post requires at least user access
		Given I visit the edit tailgate post nested resource
		Then I should be redirected to the new user session page
			And I should see an alert flash

	Scenario: Seeing the list of posts doesn't require user access
		Given I have created 3 posts
		When I visit the tailgate posts nested resource
		Then there should be 3 posts 
	
	Scenario: I can add a post as a user and see the details when complete
		Given I sign in as user
		When I visit the new tailgate post nested resource
			And I create a new post
		Then I should see the details of the new post
	
	Scenario: I can edit a post as the user who created it
		Given I previously created a post
			And I sign in as user
		When I visit the edit tailgate post nested resource
			And I edit the post
		Then the changes to the post should be saved

	Scenario: I can see all the posts as a user
		Given I sign in as user
			And I have created 3 posts
		When I visit the tailgate posts nested resource
		Then there should be 3 posts
