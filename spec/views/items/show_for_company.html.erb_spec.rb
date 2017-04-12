require 'rails_helper'

RSpec.describe "items/show_for_company", type: :view do
  specify "company does not see other companies' services" do
    item = create :item
    assign :item, item
    company = create :company
    other_company = create :company
    item.services.create!(
      attributes_for(:service).merge(company: other_company)
    )
    sign_in company
    render

    expect(rendered).not_to have_tag(".margin_left .service")
  end

  specify "company does not see other companies' services" do
    item = create :item
    company = create :company
    other_company = create :company
    item.services.create!(
      attributes_for(:service).merge(approver: company)
    )
    item.services.create!(
      attributes_for(:service).merge(approver: other_company)
    )
    sign_in company
    assign :item, item
    render

    expect(rendered).to have_tag(".service", count: 1)
  end

  specify "company does not see other companies' services" do
    item = create :item
    company = create :company
    other_company = create :company
    item.services.create!(
      attributes_for(:service).merge(company: company)
    )
    item.services.create!(
      attributes_for(:service).merge(company: other_company)
    )
    sign_in company
    assign :item, item
    render

    expect(rendered).to have_tag(".service", count: 1)
  end

  specify "company does not see other companies' services" do
    user = create :user
    item = create :item, user: user
    company = create :company
    item.services.create!(
      attributes_for(:service).merge(created_at: DateTime.parse('2017.03.13 22:30'))
    )
    item.services.create!(
      attributes_for(:service).merge(company: company, created_at: DateTime.parse('2017.03.14 22:31'))
    )
    item.services.create!(
      attributes_for(:service).merge(approver: company, created_at: DateTime.parse('2017.03.15 22:32'))
    )
    sign_in user
    assign :item, item
    render

    expect(rendered).to have_tag("strong", text: "2017-03-13 23:30:00 +0100", count: 1)
    expect(rendered).to have_tag("strong", text: "2017-03-14 23:31:00 +0100", count: 1)
    expect(rendered).to have_tag("strong", text: "2017-03-15 23:32:00 +0100", count: 1)
  end
end
