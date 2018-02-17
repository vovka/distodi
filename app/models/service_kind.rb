class ServiceKind < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :service_fields
  has_many :services, through: :service_fields
  belongs_to :company
end

# == Schema Information
#
# Table name: service_kinds
#
#  id         :integer          not null, primary key
#  title      :string
#  with_text  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
