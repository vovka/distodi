class Characteristic < ActiveRecord::Base
  belongs_to :item
  belongs_to :attribute_kind
end
