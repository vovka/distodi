FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    country do
      std_country = nil
      until std_country.present?
        std_country = ISO3166::Country.find_country_by_name Faker::Address.country
      end
      std_country
    end
    city { Faker::Address.city }
    street { Faker::Address.street_name }
    phone { Faker::PhoneNumber.subscriber_number(10) }
    postal_code { Faker::Number.number(5) }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  phone                  :string
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
#  country                :string
#  city                   :string
#  street                 :string
#  postal_code            :string
#  notice                 :string
#  picture                :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
