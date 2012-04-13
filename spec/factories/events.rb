FactoryGirl.define do
  factory :event do
    sequence(:name) {|n| "event#{n}" }
    home_team { FactoryGirl.build(:team) }
    visiting_team { FactoryGirl.build(:team) }
    event_date Date.today
    event_time Time.now
    location { FactoryGirl.build(:location) }
  end
end