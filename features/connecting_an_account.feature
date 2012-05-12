Feature: Connecting an account to another service

	Scenario: Adding facebook to an existing account
		Given I sign in as user
		

	Scenario: Adding twitter to an existing account
		Given I sign in as user
		When I visit the connect twitter user page
			And I click the twitter link
		Then my twitter data should be stored in the DB
	