Feature: User Profile

	Scenario: Returning user should see their team
		Given I login with a user who has picked a team
		Then I should be on the root page
		When I visit the user page
		Then I should see my team
