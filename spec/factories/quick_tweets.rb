FactoryGirl.define do
  factory :quick_tweet do
    sequence(:name) {|n| "quick tweet#{n}" }
    sequence(:tweet) {|n| "quick tweet text#{n}" }
    sport { FactoryGirl.create(:sport) }
  end
end