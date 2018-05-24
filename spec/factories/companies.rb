FactoryGirl.define do
  factory :company do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    name { Faker::Company.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    website { Faker::Internet.domain_name }
    verified { true }
    country do
      std_country = nil
      until std_country.present?
        std_country = ISO3166::Country.find_country_by_name Faker::Address.country
      end
      std_country
    end
    city { Faker::Address.city }
    address { Faker::Address.street_address }
    phone { "+380501234567" }
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
#  address                :string
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
#  active                 :boolean          default("true")
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default("0")
#  demo                   :boolean
#  verified               :boolean          default("false")
#
# Indexes
#
#  index_companies_on_email                 (email) UNIQUE
#  index_companies_on_invitation_token      (invitation_token) UNIQUE
#  index_companies_on_invitations_count     (invitations_count)
#  index_companies_on_invited_by_id         (invited_by_id)
#  index_companies_on_reset_password_token  (reset_password_token) UNIQUE
#
