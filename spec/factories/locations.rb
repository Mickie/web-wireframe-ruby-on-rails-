FactoryGirl.define do
  
  factory :country do
    sequence(:name) {|n| "country#{n}" }
    sequence(:abbreviation) {|n| n > 9 ? "#{n}" : "A#{n}" }
  end

  factory :state do
    sequence(:name) {|n| "state#{n}" }
    sequence(:abbreviation) {|n| n > 9 ? "#{n}" : "B#{n}" }
  end

end