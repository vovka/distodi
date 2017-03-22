FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    country { Faker::Address.country }
    city { Faker::Address.city }
    street { Faker::Address.street_name }
    phone { Faker::PhoneNumber.subscriber_number(10) }
    postal_code { Faker::Number.number(5) }
  end
end
