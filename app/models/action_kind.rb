class ActionKind < ActiveRecord::Base
  has_many :service_action_kinds
  has_many :services, through: :service_action_kinds
  has_and_belongs_to_many :categories
end

# == Schema Information
#
# Table name: action_kinds
#
#  id           :integer          not null, primary key
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  abbreviation :string
#
