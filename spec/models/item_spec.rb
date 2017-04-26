require 'spec_helper'

describe Item do
  describe "ID code" do
    include ActiveSupport::Testing::TimeHelpers

    it "calls the method after create" do
      item = build :item, user: create(:user), category: create(:category)
      allow(item).to receive(:ensure_id_code)

      item.save

      expect(item).to have_received(:ensure_id_code).at_least(:once)
    end

    it "generates unique ID" do
      country = Country["Pl"].name
      john_doe = create :user, first_name: "John",
                               last_name: "Doe",
                               country: country
      category = create :category, id: 1
      year_attribute = create :attribute_kind, title: "Year"
      release_year = create :characteristic, attribute_kind: year_attribute,
                                             value: "1986"

      item = create :item, id: 401_712, author: john_doe,
                                        category: category,
                                        characteristics: [release_year]

      expect(item.id_code).to match(/D616-JD-0001-1986-WWGM/)
    end

    it "generates unique ID with create year" do
      country = Country["Pl"].name
      john_doe = create :user, first_name: "John",
                               last_name: "Doe",
                               country: country
      category = create :category, id: 1

      item = travel_to(Time.new(2015, 2)) do
        create :item, id: 401_712, author: john_doe, category: category
      end

      expect(item.id_code).to match(/D616-JD-0001-2015-WWGM/)
    end
  end
end

# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  title       :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  picture     :string
#  token       :string
#  id_code     :string
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#
