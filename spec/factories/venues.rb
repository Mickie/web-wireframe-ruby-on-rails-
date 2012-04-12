FactoryGirl.define do
  factory :venue_type do
    sequence(:name) {|n| "venue type#{n}" }
  end
    
end