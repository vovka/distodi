require 'rails_helper'

RSpec.describe Service, type: :model do
  describe "#create" do
    it "sets pending status by default" do
      user = create :user
      company = create :company

      service = user.items.create!(attributes_for(:item))
                    .services.create!(
                      attributes_for(:service).merge(approver: company)
                    )

      expect(service.status).to eq(Service::STATUS_PENDING)
    end

    it "self approves services without approver as made by hand" do
      user = create :user

      service = user.items.create!(attributes_for(:item))
                    .services.create!(attributes_for(:service))

      expect(service.status).to eq(Service::STATUS_APPROVED)
    end
  end

  describe "#approve!" do
    it "sets status column" do
      service = create :service

      service.approve!

      expect(service.status).to eq(Service::STATUS_APPROVED)
    end
  end

  describe "#decline!" do
    it "sets status column" do
      service = create :service

      service.decline!(Faker::Lorem.sentence)

      expect(service.status).to eq(Service::STATUS_DECLINED)
    end

    it "can not be called without reason" do
      service = create :service

      expect { service.decline!(nil) }.to_not change { service.reload.status }
    end
  end

  describe "ID code" do
    include ActiveSupport::Testing::TimeHelpers

    it "calls the method after create" do
      service = build :service, item: build(:item, user: create(:user),
                                                   category: build(:category)),
                                action_kinds: create_list(:action_kind, 1,
                                                          abbreviation: "XYZ")
      allow(service).to receive(:ensure_id_code)

      service.save

      expect(service).to have_received(:ensure_id_code)
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

      item = create :item, author: john_doe,
                           category: category,
                           characteristics: [release_year]

      service = travel_to(Time.new(2017, 4, 25, 12, 0)) do
        item.services.create! id: 401_712,
                              action_kinds: create_list(:action_kind, 1,
                                                        abbreviation: "XYZ")
      end

      expect(service.id_code).to match(/XYZ616-0001-250417-WWGM/)
    end

    it "generates unique ID with create year" do
      country = Country["Pl"].name
      john_doe = create :user, first_name: "John",
                               last_name: "Doe",
                               country: country
      category = create :category, id: 1
      item = create :item, author: john_doe, category: category

      service = travel_to(Time.new(2017, 4, 25, 12, 0)) do
        item.services.create! id: 401_712,
                              action_kinds: create_list(:action_kind, 1,
                                                        abbreviation: "XYZ")
      end

      expect(service.id_code).to match(/XYZ616-0001-250417-WWGM/)
    end
  end
end

# == Schema Information
#
# Table name: services
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  item_id       :integer
#  next_control  :date
#  picture       :string
#  price         :float
#  company_id    :integer
#  confirmed     :boolean
#  status        :string           default("pending")
#  approver_id   :integer
#  approver_type :string
#  reason        :string(1023)
#  id_code       :string
#
