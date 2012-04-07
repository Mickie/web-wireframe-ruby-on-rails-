FactoryGirl.define do
  factory :division do
    sequence(:name) {|n| "division#{n}" }
    league { FactoryGirl.create(:league) }
  end
end