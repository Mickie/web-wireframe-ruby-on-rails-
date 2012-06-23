FactoryGirl.define do
  factory :post do
    sequence(:content) { |n| "content#{n}" }
  end
end