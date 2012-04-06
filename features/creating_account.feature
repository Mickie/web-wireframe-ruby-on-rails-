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
			
	Scenario: Create account via twitter
		Given I visit the new user registration page
		When I click the twitter link
		Then I should be on the new user registration page
			And I should see Almost There text
			And there should be hidden twitter data
		When I submit valid email and password
		Then I should be on the user page
			And my twitter data should be stored in the DB
			
