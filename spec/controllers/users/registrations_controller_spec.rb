require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  render_views

  describe "POST #create" do
    def valid_attributes
      {
        user: {
          first_name: "John",
          email: "test@example.com",
          password: "11111111",
          password_confirmation: "11111111"
        }
      }
    end

    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    it "sends email" do
      expect { post :create, valid_attributes }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "sends email to the user" do
      post :create, valid_attributes
      msg = ActionMailer::Base.deliveries.last

      expect([
        msg.to,
        msg.subject
      ]).to eq([
        [valid_attributes[:user][:email]],
        "Confirmation Email"
      ])
    end

    it "creates demo data for the user" do
      create_list :category, 3, :with_service_kinds, :with_action_kinds
      allow_any_instance_of(DemoDataService).to receive(:picture_path) do
        Rails.root.join("spec/fixtures/an_image.jpg")
      end

      post :create, valid_attributes
      user = User.where(email: valid_attributes[:user][:email]).first

      expect(user.items.with_demo.size).to eq(3)
      expect(user.services.with_demo.count).to eq(30)
    end
  end
end
