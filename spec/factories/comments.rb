FactoryGirl.define do
  factory :comment do
    sequence(:content) { |n| "content#{n}" }
  end
end