describe CompaniesController do
  render_views

  describe "DELETE #destroy" do
    it "returns http success" do
      company = FactoryGirl.create :company, password: "11111111", password_confirmation: "11111111"
      sign_in company

      delete :destroy, id: company.to_param, company: { password: "11111111" }

      expect(response).to redirect_to(root_path)
    end

    it "logs out company" do
      company = FactoryGirl.create :company, password: "11111111", password_confirmation: "11111111"
      sign_in company

      delete :destroy, id: company.to_param, company: { password: "11111111" }

      expect(controller.current_company).to be_nil
    end

    it "defines an instance variable" do
      company = create :company, password: "11111111", password_confirmation: "11111111"
      sign_in company

      delete :destroy, id: company.to_param, company: { password: "11111111" }

      expect(assigns(:company)).to be_present
    end

     it "should increment the count" do
      company = create :company, password: "11111111", password_confirmation: "11111111"
      sign_in company

      expect {
        delete :destroy, id: company.to_param, company: { password: "11111111" }
      }.to change { Company.count }.from(1).to(0)
    end
  end
end
