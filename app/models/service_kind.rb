class ServiceKind < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :service_fields
  has_many :services, through: :service_fields
end
