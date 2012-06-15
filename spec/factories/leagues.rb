FactoryGirl.define do
  factory :league do
    sequence(:name) {|n| "league#{n}" }
    sport { FactoryGirl.create(:sport) }
    visible true
  end
end