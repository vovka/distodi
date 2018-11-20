FactoryGirl.define do
  factory :service_field do
    
  end
end

# == Schema Information
#
# Table name: service_fields
#
#  id              :integer          not null, primary key
#  service_id      :integer
#  service_kind_id :integer
#  text            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_service_fields_on_service_id       (service_id)
#  index_service_fields_on_service_kind_id  (service_kind_id)
#
