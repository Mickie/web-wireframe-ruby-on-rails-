FactoryGirl.define do
  
  factory :team do
    sequence(:name) {|n| "team_foo#{n}" }
    league { FactoryGirl.create(:league ) }
    sport { league.sport }
    location { FactoryGirl.create(:location) }
    social_info { FactoryGirl.create(:social_info) }
  end

end