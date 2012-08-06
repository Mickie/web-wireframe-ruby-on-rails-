Feature: VenueTypes Resource

	Scenario: Adding a venue type requires admin access
		Given I visit the new venue type page
		Then I should be redirected to the new admin session page

	Scenario: Editing a venue type requires admin access
		Given I visit the edit venue type page
		Then I should be redirected to the new admin session page

	Scenario: Seeing the list of venue types requires admin access
		Given I visit the venue types page
		Then I should be redirected to the new admin session page
		
	Scenario: I can add a venue type as an admin and see the details when complete
		Given I sign in as admin
		When I visit the new venue type page
			And I create a new venue type
		Then I should see the details of the new venue type
			And I should be able to edit it
			
	Scenario: I can edit a venue type as an admin
		Given I sign in as admin
		When I visit the edit venue type page
			And I edit the venue type
		Then the changes to the venue type should be saved

	Scenario: The name of a venue type should be unique
		Given I sign in as admin
			And I have added 2 venue types with names
		When I visit the edit venue type page
			And I edit the venue type with duplicate name
		Then the changes to the venue type should not be saved
	
	Scenario: I can see all the venue types as an admin
		Given I sign in as admin
			And I have added 3 venue types with names
		When I visit the venue types page
		Then I should see 3 venue types with names
