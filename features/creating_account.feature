Feature: Creating Accounts

	Scenario: Create account via email and password
		Given I visit the new user registration page
		When I submit valid email and password
		Then I should be on the user page
			And I should see a signout link

	Scenario: Create account via facebook
		Given I visit the new user registration page
		When I click the facebook link
		Then I should be on the user page
			And I should see a signout link
			And my facebook data should be stored in the DB
			
			
