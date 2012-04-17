FactoryGirl.define do

  factory :person, aliases:[:coach, :journalist, :superfan, :blogger] do
    first_name "John"
    last_name "Smith"
    home_town "everywhere"
    home_school "somewhere"
    position "line"
    social_info { FactoryGirl.build(:social_info) }
    team { FactoryGirl.build( :team ) }
  end

  factory :athlete do
    first_name "John"
    last_name "Athlete"
    home_town "everywhere"
    home_school "somewhere"
    position "back"
    social_info { FactoryGirl.build(:social_info) }
    team { FactoryGirl.build( :team ) }
  end


end

