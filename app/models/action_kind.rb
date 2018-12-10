class ActionKind < ActiveRecord::Base
  ROAD_REGEXP = /road/i.freeze

  acts_as_list

  default_scope { order(:position) }

  has_many :service_action_kinds
  has_many :services, through: :service_action_kinds
  has_and_belongs_to_many :categories

  def to_blockchain_hash
    {
      id: id
    }
  end

  def road?
    (title =~ ROAD_REGEXP).present?
  end
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
#  position     :integer
#
