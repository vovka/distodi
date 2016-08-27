class ServiceActionKind < ActiveRecord::Base
  belongs_to :service
  belongs_to :action_kind
end
