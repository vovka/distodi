class ServiceActionKind < ActiveRecord::Base
  belongs_to :service
  belongs_to :action_kind
end

# == Schema Information
#
# Table name: service_action_kinds
#
#  id             :integer          not null, primary key
#  service_id     :integer
#  action_kind_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_service_action_kinds_on_action_kind_id  (action_kind_id)
#  index_service_action_kinds_on_service_id      (service_id)
#
