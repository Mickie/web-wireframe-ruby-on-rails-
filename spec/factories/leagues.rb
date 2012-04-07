FactoryGirl.define do
  factory :league do
    sequence(:name) {|n| "league#{n}" }
  end
end