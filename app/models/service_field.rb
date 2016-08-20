class ServiceField < ActiveRecord::Base
  belongs_to :service
  belongs_to :service_kind
end
