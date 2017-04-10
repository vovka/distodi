FactoryGirl.define do
  factory :company do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    name { Faker::Name.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    website "spice.com"
    country { Faker::Address.country }
    city { Faker::Address.city }
    street { Faker::Address.street_name }
    phone { Faker::PhoneNumber.subscriber_number(10) }
    postal_code { Faker::Number.number(5) }
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                     :integer          not null, primary key
#  name                   :string
#  phone                  :string
#  country                :string
#  city                   :string
#  street                 :string
#  postal_code            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  website                :string
#  notice                 :string
#  first_name             :string
#  last_name              :string
#  picture                :string
#
# Indexes
#
#  index_companies_on_email                 (email) UNIQUE
#  index_companies_on_reset_password_token  (reset_password_token) UNIQUE
#
