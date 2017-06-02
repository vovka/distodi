require "rails_helper"

RSpec.describe "items/show", type: :view do
  describe "services list" do
    context "company" do
      before do
        user = create :user
        company = create :company
        user.items.create!(attributes_for(:item))
            .services.create!(
              attributes_for(:service).merge(company: company,
                                             approver: company)
            )
        sign_in company
        assign :item, user.items.first
        # allow(view).to receive(:policy) { |service| ServicePolicy.new(user, service) }
        def view.policy(record, company = company)
          Pundit.policy(company, record)
        end

        render
      end

      xspecify "sees confirm for pending service" do
        expect(rendered).to have_tag("td > a", text: "Confirm")
      end

      xspecify "sees decline for pending service" do
        expect(rendered).to have_tag("td div", text: "Decline")
        expect(rendered).to have_tag("td input[type=submit][value=Decline]")
      end

      specify "does not see delete for services" do
        expect(rendered).not_to have_tag("td > a", text: "Delete")
      end
    end

    context "user" do
      before do
        user = create :user
        company = create :company
        user.items.create!(attributes_for(:item))
            .services.create!(
              attributes_for(:service).merge(company: company,
                                             approver: company)
            )
        sign_in user
        assign :item, user.items.first
        # allow(view).to receive(:policy) { |service| ServicePolicy.new(user, service) }
        def view.policy(record, user = user)
          Pundit.policy(user, record)
        end

        render
      end

      specify "does not see confirm for pending service" do
        expect(rendered).not_to have_tag("td > a", text: "Confirm")
      end

      specify "does not see decline for pending service" do
        expect(rendered).not_to have_tag("td > a", text: "Decline")
      end

      xspecify "sees delete for services" do
        expect(rendered).to have_tag("td > a", text: "Delete")
      end

      specify "transfer items field is present" do
        expect(rendered).to have_tag("input[name='user_identifier']")
      end
    end
  end
end
