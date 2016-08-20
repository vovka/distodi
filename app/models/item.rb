class Item < ActiveRecord::Base
  has_many :characteristics
  has_many :attribute_kinds, through: :characteristics
  belongs_to :category
  belongs_to :user

  mount_uploader :picture, PictureUploader
end
