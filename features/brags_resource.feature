Feature: Brags Resource

	Scenario: Adding a brag requires admin access
		Given I visit the new brag page
		Then I should be redirected to the new admin session page

	Scenario: Editing a brag requires admin access
		Given I visit the edit brag page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of brags requires admin access
		Given I visit the brags page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a brag as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new brag page
			And I create a new brag
		Then I should see the details of the new brag
			And I should be able to edit it
	
	Scenario: I can edit a brag as an admin
		Given I sign in as admin
		When I visit the edit brag page
			And I edit the brag
		Then the changes to the brag should be saved
		
	Scenario: I can see all the brags as an admin
		Given I sign in as admin
			And I have added 3 brags with contents
		When I visit the brags page
		Then I should see 3 brags with contents
