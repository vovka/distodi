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
      category = create :category, id: 111_111
      year_attribute = create :attribute_kind, title: "Year"
      release_year = create :characteristic, attribute_kind: year_attribute,
                                             value: "1986"

      item = create :item, id: 401_712, user: john_doe,
                                        category: category,
                                        characteristics: [release_year]

      expect(item.id_code).to eq("D616-JD-111111-1986-WWGM")
    end

    it "generates unique ID with create year" do
      country = Country["Pl"].name
      john_doe = create :user, first_name: "John",
                               last_name: "Doe",
                               country: country
      category = create :category, id: 111_111

      item = travel_to(Time.new(2015, 2)) do
        create :item, id: 401_712, user: john_doe, category: category, characteristics: []
      end

      expect(item.id_code).to eq("D616-JD-111111-2015-WWGM")
    end

    describe "validations" do
      def build_item_without(*rejected_keys)
        user_attributes = {}
        user_attributes[:first_name] = if rejected_keys.include?(:first_name)
          nil
        else
          "John"
        end
        user_attributes[:last_name] = if rejected_keys.include?(:last_name)
          nil
        else
          "Doe"
        end
        user_attributes[:country] = if rejected_keys.include?(:country)
          nil
        else
          Country["Pl"].name
        end
        john_doe = if rejected_keys.include?(:user)
          nil
        else
          build :user, user_attributes
        end
        category = if rejected_keys.include?(:category)
          nil
        else
          build :category, id: 1
        end
        release_year = if rejected_keys.include?(:year)
          nil
        else
          year_attribute = build :attribute_kind, title: "Year"
          build :characteristic, attribute_kind: year_attribute,
                                                 value: "1986"
        end

        item = build :item, id: 401_712, user: john_doe,
                                         category: category,
                                         characteristics: [release_year].compact
      end

      def build_valid_item
        build_item_without()
      end

      it "is invalid without first_name" do
        item = build_item_without :first_name

        expect(item).to be_invalid
      end

      it "is invalid without last_name" do
        item = build_item_without :last_name

        expect(item).to be_invalid
      end

      it "is invalid without country" do
        item = build_item_without :country

        expect(item).to be_invalid
      end

      it "is invalid without user" do
        item = build_item_without :user

        expect(item).to be_invalid
      end

      it "is invalid without category" do
        item = build_item_without :category

        expect(item).to be_invalid
      end

      it "is invalid with imagine country" do
        item = build_valid_item
        item.user.country = "Kingdom of Amber"

        expect(item).to be_invalid
      end

      it "is valid without year" do
        item = build_item_without :year

        expect(item).to be_valid
      end
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
