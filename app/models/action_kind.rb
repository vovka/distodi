class ActionKind < ActiveRecord::Base
  has_many :service_action_kinds
  has_many :services, through: :service_action_kinds
  has_and_belongs_to_many :categories
end
