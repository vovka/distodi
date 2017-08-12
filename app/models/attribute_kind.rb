class AttributeKind < ActiveRecord::Base
  BRAND = "Brand"
  MODEL = "Model"

  has_and_belongs_to_many :categories
  has_many :characteristics
  has_many :items, through: :characteristics

  def brand?
    title == BRAND
  end

  def model?
    title == MODEL
  end
end

# == Schema Information
#
# Table name: attribute_kinds
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
