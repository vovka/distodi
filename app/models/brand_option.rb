class BrandOption < ActiveRecord::Base
  has_many :model_options
  belongs_to :category

  accepts_nested_attributes_for :model_options

  validates :name, uniqueness: { scope: :category_id }
  validates :category_id, presence: true
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
