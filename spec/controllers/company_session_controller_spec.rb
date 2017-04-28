require 'rails_helper'

describe Companies::SessionsController do
  describe "POST create" do
    it "redirects company to company page" do
      @request.env["devise.mapping"] = Devise.mappings[:company]
      company = create :company, password: "11111111",
                                 password_confirmation: "11111111"

      post :create, company: { email: company.email, password: "11111111" }

      expect(response).to redirect_to(company_path(company))
    end
  end
end
