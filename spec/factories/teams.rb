FactoryGirl.define do
  
  factory :team do
    sequence(:name) {|n| "team_foo#{n}" }
    league { FactoryGirl.create(:league ) }
    sport { league.sport }
    location { FactoryGirl.create(:location) }
    social_info { FactoryGirl.create(:social_info) }
    sequence(:slug) { |n| "team-foo-slug-#{n}" }
    sequence(:espn_team_id) {|n| n }
    espn_team_url { "http://espn.go.com/college-football/team/_/id/#{espn_team_id}/#{slug}" }
  end

end