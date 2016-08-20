class Service < ActiveRecord::Base
  has_many :service_fields
  has_many :service_kinds, through: :service_fields
end
