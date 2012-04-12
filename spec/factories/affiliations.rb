FactoryGirl.define do
  factory :affiliation do
    sequence(:name) {|n| "affiliation#{n}" }
    location { FactoryGirl.create(:location) }
    social_info { FactoryGirl.create(:social_info) }
  end
end