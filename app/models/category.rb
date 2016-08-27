class Category < ActiveRecord::Base
  has_and_belongs_to_many :attribute_kinds
  has_and_belongs_to_many :service_kinds
  has_and_belongs_to_many :action_kinds
  has_many :items
end
