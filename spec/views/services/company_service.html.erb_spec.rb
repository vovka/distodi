require 'rails_helper'

RSpec.describe "services/company_service", type: :view do
  before do
    service = create :service
    assign :service, service.decorate
    assign :action_kinds, create_list(:action_kind, 2)
    assign :service_kinds, create_list(:service_kind, 5)
    controller.params[:token] = "some_value"
  end

  it "has token form field" do
    render

    expect(rendered).to have_tag("input[name=token][value=some_value]")
  end

  context "unauthenticated user" do
    specify "does not see companies select box" do
      render

      expect(rendered).to_not have_tag("select[name='service[company_id]']")
    end
  end

  context "logged in company" do
    specify "does not see companies select box" do
      sign_in create(:company)

      render

      expect(rendered).to_not have_tag("select[name='service[company_id]']")
    end
  end
end
