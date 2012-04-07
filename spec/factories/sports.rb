FactoryGirl.define do
  factory :sport do
    sequence(:name) {|n| "sport#{n}" }
  end
end