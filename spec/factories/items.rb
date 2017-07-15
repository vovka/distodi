FactoryGirl.define do
  factory :item do
    title "car"
    characteristics do
      year_attribute = build :attribute_kind, title: "Year"
      create_list :characteristic, 1, { attribute_kind: year_attribute, value: "1986" }
    end
    user { build :user }
    category { build :category }
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
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#
