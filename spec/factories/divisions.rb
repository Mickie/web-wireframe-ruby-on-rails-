FactoryGirl.define do
  factory :division do
    sequence(:name) {|n| "division#{n}" }
    conference { FactoryGirl.create(:conference) }
  end
end