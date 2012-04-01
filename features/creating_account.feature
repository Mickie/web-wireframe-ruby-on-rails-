Feature: Creating Accounts

	Scenario: Create account via email and password
		Given a user visits the registration page
		When the user submits valid email and password
		Then he should see his profile page
			And he should see a signout link

	Scenario: Create account via facebook
		Given a user visits the registration page
		When he clicks the facebook link
		Then he should see his profile page
			And he should see a signout link
			
	Scenario: Create account via twitter
		Given a user visits the registration page
		When he clicks the twitter link
		Then he should see almost there page
			And there should be hidden twitter data
		When the user submits valid email and password
		Then he should see his profile page
			And his twitter data should be store in the DB
			
