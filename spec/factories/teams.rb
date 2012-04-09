FactoryGirl.define do
  
  factory :team do
    sequence(:name) {|n| "team_foo#{n}" }
    twitter_name '@team_foo'
    facebook_page_url 'http://www.facebook.com/team_foo'
    web_url 'http://www.team_foo.com'
    league { FactoryGirl.create(:league ) }
    sport { league.sport }
    location { FactoryGirl.create(:location) }
  end

end