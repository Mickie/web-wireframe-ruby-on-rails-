FactoryGirl.define do
  factory :game_watch do
    sequence(:name) {|n| "game watch#{n}" }
    venue { FactoryGirl.build(:venue) }
    event { FactoryGirl.build(:event) }
    creator { FactoryGirl.build(:user) }
  end
end