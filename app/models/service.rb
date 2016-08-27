class Service < ActiveRecord::Base
  has_many :service_fields
  has_many :service_kinds, through: :service_fields
  has_many :service_action_kinds
  has_many :action_kinds, through: :service_action_kinds
  belongs_to :item
end
