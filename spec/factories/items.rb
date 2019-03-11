FactoryGirl.define do
  factory :item do
    sequence(:title) { |n| "car ##{n}" }
    characteristics do
      year_attribute = build :attribute_kind, title: "Year"
      create_list :characteristic, 1, { attribute_kind: year_attribute, value: "1986" }
    end
    user { build :user }
    category { build :category }
    picture { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'an_image.jpg'), 'image/jpeg') }
  end
end

# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  title              :string
#  category_id        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  picture            :string
#  token              :string
#  id_code            :string
#  transferring_to_id :integer
#  demo               :boolean
#  picture2           :string
#  picture3           :string
#  picture4           :string
#  picture5           :string
#  comment            :string(2000)
#  user_type          :string
#  archivation        :boolean          default("false")
#  archived           :boolean          default("false")
#  deleted_at         :datetime
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#  index_items_on_deleted_at   (deleted_at)
#
