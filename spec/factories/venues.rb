FactoryGirl.define do
  factory :venue_type do
    sequence(:name) { |n| "venue type#{n}" }
  end
    
  factory :venue do
    sequence(:name) { |n| "venue#{n}" }
    venue_type { FactoryGirl.build(:venue_type) }
    location { FactoryGirl.build(:location) }
    social_info { FactoryGirl.build(:social_info) }
  end
end