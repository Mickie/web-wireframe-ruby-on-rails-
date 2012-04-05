FactoryGirl.define do

  factory :person, aliases:[:coach, :athlete, :journalist, :superfan, :blogger] do
    first_name "John"
    last_name "Smith"
  end

end

