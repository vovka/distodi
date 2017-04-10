class AttributeKind < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :characteristics
  has_many :items, through: :characteristics
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
