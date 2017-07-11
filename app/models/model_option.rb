class ModelOption < ActiveRecord::Base
  belongs_to :brand_option

  validates_uniqueness_of :name, scope: :brand_option_id
end

# == Schema Information
#
# Table name: model_options
#
#  id              :integer          not null, primary key
#  name            :string
#  brand_option_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
