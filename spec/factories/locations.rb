FactoryGirl.define do
  
  factory :location do
    sequence(:name) {|n| "location#{n}" }
    address1 '12 Seahawks Way'
    city 'Renton'
    state { State.find_by_abbreviation('WA')}
    postal_code '98056'
    country {Country.find_by_abbreviation('US')}
  end

end