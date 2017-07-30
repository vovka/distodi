require 'rails_helper'

RSpec.describe User, type: :model do
  describe "services" do
    describe "#services" do
      it "contains services created by the user" do
        user = create :user
        service = user.items.create!(attributes_for(:item))
                      .services.create!(attributes_for(:service))
        create :service

        expect(user.services).to eq([service])
      end
    end

    describe "#assigned_services" do
      it "contains serices assigned to the user" do
        user = create :user
        company = create :company
        service = company.services.create!(
          attributes_for(:service).merge(approver: user)
        )
        company.services.create!(attributes_for(:service))

        expect(user.assigned_services).to eq([service])
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  phone                  :string
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
#  country                :string
#  city                   :string
#  address                :string
#  postal_code            :string
#  notice                 :string
#  picture                :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
