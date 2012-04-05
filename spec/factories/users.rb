FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "example#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
  end
end