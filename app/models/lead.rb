class Lead < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true, email: true
end

# == Schema Information
#
# Table name: leads
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
