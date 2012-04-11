FactoryGirl.define do
  factory :affiliation do
    sequence(:name) {|n| "affiliation#{n}" }
    location { FactoryGirl.create(:location) }
  end
end