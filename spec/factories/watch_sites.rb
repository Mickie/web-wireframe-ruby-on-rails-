FactoryGirl.define do
  factory :watch_site do
    sequence(:name) {|n| "watch site#{n}" }
    venue { FactoryGirl.build(:venue) }
    team { FactoryGirl.build(:team) }
  end
end