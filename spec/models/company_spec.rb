require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "services" do
    describe "#services" do
      it "contains services created by the company" do
        company = create :company
        service = company.services.create!(attributes_for(:service))
        create :service

        expect(company.services).to eq([service])
      end
    end

    describe "#assigned_services" do
      it "contains serices assigned to the company" do
        user = create :user
        company = create :company
        service = user.items.create!(attributes_for(:item))
                      .services.create!(
                        attributes_for(:service).merge(approver: company)
                      )
        user.items.create!(attributes_for(:item))
            .services.create!(attributes_for(:service))

        expect(company.assigned_services).to eq([service])
      end

      it "change active for true" do
        company = create :company, active: false
        allow(company).to receive(:invited_to_sign_up?).and_return(:true)

        company.accept_invitation!

        expect(company.active).to eq(true)
      end
    end
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                     :integer          not null, primary key
#  name                   :string
#  phone                  :string
#  country                :string
#  city                   :string
#  street                 :string
#  postal_code            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  website                :string
#  notice                 :string
#  first_name             :string
#  last_name              :string
#  picture                :string
#  active                 :boolean          default("true")
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default("0")
#  demo                   :boolean
#
# Indexes
#
#  index_companies_on_email                 (email) UNIQUE
#  index_companies_on_invitation_token      (invitation_token) UNIQUE
#  index_companies_on_invitations_count     (invitations_count)
#  index_companies_on_invited_by_id         (invited_by_id)
#  index_companies_on_reset_password_token  (reset_password_token) UNIQUE
#
