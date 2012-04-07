FactoryGirl.define do
  factory :conference do
    sequence(:name) {|n| "conference#{n}" }
    league { FactoryGirl.create(:league) }
  end
end