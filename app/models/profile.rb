class Profile < ActiveRecord::Base
  belongs_to :user
end

# == Schema Information
#
# Table name: profiles
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  facebook_uid      :string
#  google_oauth2_uid :string
#  twitter_uid       :string
#  linkedin_uid      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
