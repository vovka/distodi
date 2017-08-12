class Category < ActiveRecord::Base
  has_and_belongs_to_many :attribute_kinds
  has_and_belongs_to_many :service_kinds
  has_and_belongs_to_many :action_kinds
  has_many :items
  has_many :brand_options
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
