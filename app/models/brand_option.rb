class BrandOption < ActiveRecord::Base
  has_many :model_options
  belongs_to :category, dependent: :destroy

  accepts_nested_attributes_for :model_options

  validates_uniqueness_of :name, scope: :category_id
end

# == Schema Information
#
# Table name: brand_options
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
