class Item < ActiveRecord::Base
  has_many :characteristics
  has_many :attribute_kinds, through: :characteristics
  belongs_to :category
end
