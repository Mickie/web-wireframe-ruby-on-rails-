FactoryGirl.define do
  
  factory :location do
    sequence(:name) {|n| "location#{n}" }
    address1 '100 Main Street'
    address2 'Suite 100'
    city 'Tooltown'
    state { State.find_by_abbreviation('WA')}
    postal_code '98123'
    country {Country.first}
    latitude 100.0
    longitude 100.0
  end

end