require 'rails_helper'

RSpec.describe Service, type: :model do
  include ActiveSupport::Testing::TimeHelpers

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
    it "calls the method after create" do
      service = build :service
      allow(service).to receive(:ensure_id_code)

      service.save

      expect(service).to have_received(:ensure_id_code)
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

      item = create :item, user: john_doe,
                           category: category,
                           characteristics: [release_year]

      service = travel_to(Time.zone.parse("2017-4-25 12:00")) do
        item.services.create! id: 401_712,
                              action_kinds: create_list(:action_kind, 1,
                                                        abbreviation: "XYZ")
      end

      expect(service.id_code).to match("XYZ616-111111-250417-WWGM")
    end

    it "generates unique ID with create year" do
      country = Country["Pl"].name
      john_doe = create :user, first_name: "John",
                               last_name: "Doe",
                               country: country
      category = create :category, id: 111_111
      item = create :item, user: john_doe, category: category

      service = travel_to(Time.zone.parse("2017-4-25 12:00")) do
        item.services.create! id: 401_712,
                              action_kinds: create_list(:action_kind, 1,
                                                        abbreviation: "XYZ")
      end

      expect(service.id_code).to match("XYZ616-111111-250417-WWGM")
    end

    describe "validations" do
      def build_service_without(*rejected_keys)
        user_attributes = {}
        user_attributes[:first_name] = "John"
        user_attributes[:last_name] = "Doe"
        user_attributes[:country] = Country["Pl"].name
        john_doe = build :user, user_attributes
        category = build :category, id: 111_111
        item = create :item, user: john_doe, category: category

        action_kinds = if rejected_keys.include?(:action_kind)
          []
        else
          build_list(:action_kind, 1, abbreviation: "XYZ")
        end

        item.services.build id: 401_712, action_kinds: action_kinds.compact
      end

      it "is invalid without action kinds" do
        service = build_service_without :action_kind

        expect(service).to be_invalid
      end
    end
  end

  describe ".to_csv" do
    before { allow(I18n).to receive(:locale).and_return(:cs) }

    it "generates CSV" do
      collection = travel_to(Time.zone.parse("2017-12-31 12:00")) do
        create_list :service, 2, price: 123.45
      end

      expect(Service.to_csv(collection)).to include(<<-EOS)
Id code,Approver,Created at,Updated at,Item,Next control,Price,Company,Status,Reason
EOS
      expect(Service.to_csv(collection)).to include(<<-EOS)
"",Ne 31. Prosinec 2017 12:00 +0100,Ne 31. Prosinec 2017 12:00 +0100,car,"","123,45 Kč","",Approved,
EOS
      expect(Service.to_csv(collection)).to include(<<-EOS)
"",Ne 31. Prosinec 2017 12:00 +0100,Ne 31. Prosinec 2017 12:00 +0100,car,"","123,45 Kč","",Approved,
EOS
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
#  demo          :boolean
#
