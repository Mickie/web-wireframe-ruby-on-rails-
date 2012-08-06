FactoryGirl.define do
  factory :brag do
    sequence(:content) {|n| "brag#{n}" }
  end
end