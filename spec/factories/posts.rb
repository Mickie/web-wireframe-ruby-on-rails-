FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "post#{n}" }
    sequence(:content) { |n| "content#{n}" }
  end
end