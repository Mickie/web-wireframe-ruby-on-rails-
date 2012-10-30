FactoryGirl.define do
  factory :tailgate do
    sequence(:name) {|n| "tailgate_#{n}" }
    team { FactoryGirl.create(:team) }
    user { FactoryGirl.create(:user) }
    topic_tags "#goIrish #ndfootball"
    official true
  end
end