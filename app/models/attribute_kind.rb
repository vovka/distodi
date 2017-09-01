class AttributeKind < ActiveRecord::Base
  BRAND = "Brand".freeze
  MODEL = "Model".freeze
  YEAR = "Year".freeze

  has_and_belongs_to_many :categories
  has_many :characteristics
  has_many :items, through: :characteristics

  def brand?
    title == BRAND
  end

  def model?
    title == MODEL
  end

  def year?
    title == YEAR
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
