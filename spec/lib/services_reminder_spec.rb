require 'spec_helper'

describe ServicesReminder do
  describe "#fetch_services" do
    include ActiveSupport::Testing::TimeHelpers

    it "fetches correct services" do
      test_time = Time.current
      approver = create :company
      travel_to(test_time - ServicesReminder::REMINDER_TIMESPAN + 1.second) do
        create :service, status: Service::STATUS_PENDING, approver: approver
      end
      service = nil
      travel_to(test_time - ServicesReminder::REMINDER_TIMESPAN - 1.second) do
        create :service, status: Service::STATUS_APPROVED, approver: approver
        service = create :service, status: Service::STATUS_PENDING, approver: approver
      end
      travel_to(test_time) do
        object_under_test = ServicesReminder.new

        result = object_under_test.send :fetch_services

        expect(result).to match_array([service])
      end
    end
  end

  describe "#fetch_emails" do
    it "fetches correct emails" do
      approver = create :company, email: 'test@example.com'
      services = [
        create(:service, status: Service::STATUS_PENDING, approver: approver),
        create(:service, status: Service::STATUS_PENDING, approver: approver),
        create(:service, status: Service::STATUS_PENDING)
      ]
      object_under_test = ServicesReminder.new

      emails = object_under_test.send :fetch_emails, services

      expect(emails).to match ['test@example.com']
    end
  end

  describe "#deliver" do
    it "sends emails" do
      mailer = double :mailer
      allow(mailer).to receive_message_chain(:reminder_service_email, :deliver_now!)
      object_under_test = ServicesReminder.new mailer

      object_under_test.send :deliver, ['test@example.com']

      expect(mailer).to have_received(:reminder_service_email).with("test@example.com")
    end
  end
end
