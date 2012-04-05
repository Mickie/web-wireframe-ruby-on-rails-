FactoryGirl.define do
  factory :admin do
    sequence(:email) {|n| "admin#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
  end
end