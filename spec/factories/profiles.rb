FactoryGirl.define do
  factory :profile do
    user nil
    facebook "MyString"
    google_oauth2 "MyString"
    twitter "MyString"
    linkedin "MyString"
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  company_id   :integer
#  facebook_uid :string
#  google_uid   :string
#  twitter_uid  :string
#  linkedin_uid :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_profiles_on_company_id  (company_id)
#  index_profiles_on_user_id     (user_id)
#
