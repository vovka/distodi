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
#
