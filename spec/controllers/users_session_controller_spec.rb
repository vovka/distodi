require 'rails_helper'

describe Users::SessionsController do
	describe "POST create" do
    it "redirects user to user page" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = create :user, password: "11111111",
                           password_confirmation: "11111111"

      post :create, user: { email: user.email, password: "11111111" }

      expect(response).to redirect_to(dashboard_path)
    end
  end
end
