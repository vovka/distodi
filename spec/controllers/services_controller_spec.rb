require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  render_views

  describe "PATCH approve" do
    specify "unauthenticated user can not approve a service" do
      user = create :user
      company = create :company
      service = company.services.create!(
        attributes_for(:service).merge(approver: user)
      )

      expect do
        expect do
          patch :approve, id: service.to_param
        end.to raise_error(UncaughtThrowError)
      end.to_not change { service.reload.status }
    end

    specify "user can approve service assigned to him" do
      user = create :user
      company = create :company
      service = company.services.create!(
        attributes_for(:service).merge(approver: user)
      )
      sign_in user

      expect do
        patch :approve, id: service.to_param
      end.to change { service.reload.status }.from(Service::STATUS_PENDING)
                                             .to(Service::STATUS_APPROVED)
    end

    specify "user can not approve service not assigned to him" do
      user = create :user
      other_user = create :user
      company = create :company
      service = company.services.create!(
        attributes_for(:service).merge(approver: other_user)
      )
      sign_in user

      expect do
        patch :approve, id: service.to_param
      end.to_not change { service.reload.status }
    end

    specify "company can approve service assigned to it" do
      company = create :company
      user = create :user
      service = user.items.create!(attributes_for(:item))
                    .services.create!(
                      attributes_for(:service).merge(approver: company)
                    )
      sign_in company

      expect do
        patch :approve, id: service.to_param
      end.to change { service.reload.status }.from(Service::STATUS_PENDING)
                                             .to(Service::STATUS_APPROVED)
    end

    specify "company can not approve service not assigned to it" do
      company = create :company
      other_company = create :company
      user = create :user
      service = user.items
                    .create!(attributes_for(:item))
                    .services.create!(
                      attributes_for(:service).merge(approver: other_company)
                    )
      sign_in company

      expect do
        patch :approve, id: service.to_param
      end.to_not change { service.reload.status }
    end
  end

  describe "PATCH decline" do
    specify "unauthenticated user can not decline a service" do
      user = create :user
      company = create :company
      service = company.services.create!(
        attributes_for(:service).merge(approver: user)
      )

      expect do
        expect do
          patch :decline, id: service.to_param,
                          service: { reason: Faker::Lorem.sentence }
        end.to raise_error(UncaughtThrowError)
      end.to_not change { service.reload.status }
    end

    specify "user can decline service assigned to him" do
      user = create :user
      company = create :company
      service = company.services.create!(
        attributes_for(:service).merge(approver: user)
      )
      sign_in user

      expect do
        patch :decline, id: service.to_param, service: { reason: Faker::Lorem.sentence }
      end.to change { service.reload.status }.from(Service::STATUS_PENDING)
                                             .to(Service::STATUS_DECLINED)
    end

    specify "user can not decline service not assigned to him" do
      user = create :user
      other_user = create :user
      company = create :company
      service = company.services.create!(
        attributes_for(:service).merge(approver: other_user)
      )
      sign_in user

      expect do
        patch :decline, id: service.to_param, service: { reason: Faker::Lorem.sentence }
      end.to_not change { service.reload.status }
    end

    specify "company can decline service assigned to it" do
      company = create :company
      user = create :user
      service = user.items.create!(attributes_for(:item))
                    .services.create!(
                      attributes_for(:service).merge(approver: company)
                    )
      sign_in company

      expect do
        patch :decline, id: service.to_param, service: { reason: Faker::Lorem.sentence }
      end.to change { service.reload.status }.from(Service::STATUS_PENDING)
                                             .to(Service::STATUS_DECLINED)
    end

    specify "company can not decline service not assigned to it" do
      company = create :company
      other_company = create :company
      user = create :user
      service = user.items.create!(attributes_for(:item))
                    .services.create!(
                      attributes_for(:service).merge(approver: other_company)
                    )
      sign_in company

      expect do
        patch :decline, id: service.to_param, service: { reason: Faker::Lorem.sentence }
      end.to_not change { service.reload.status }
    end
  end

  describe "POST create" do
    def valid_params
      action_kinds = create_list :action_kind, 2
      service_kinds = create_list :service_kind, 3
      {
        "action_kind" => Hash[
          action_kinds.map { |action_kind| [action_kind.id.to_s, "true"] }
        ],
        "service_kind" => Hash[
          service_kinds.map { |service_kind| [service_kind.id.to_s, "true"] }
        ],
        "service_fields" => Hash[
          service_kinds.map { |service_kind|
            [service_kind.id.to_s, Faker::Lorem.sentence]
          }
        ]
      }
    end

    context "unauthenticated user" do
      specify "can create service (from the permalinked page)" do
        expect do
          item = create :item
          post :create, valid_params.merge(service: attributes_for(:service),
                                           token: item.token)
        end.to change { Service.count }.by(1)
      end

      specify "can not set company" do
        item = create :item
        company = create :company

        post :create, valid_params.merge(
          service: attributes_for(:service).merge(company_id: company.id),
          token: item.token
        )

        expect(Service.last.company).to be_nil
      end

      specify "can not set item" do
        item = create :item
        other_item = create :item

        post :create, valid_params.merge({
          service: attributes_for(:service).merge({
            item_id: other_item.id
          }),
          token: item.token
        })

        expect(Service.last.item).to_not eq(other_item)
      end

      specify "sets item by default using token value" do
        item = create :item

        post :create, valid_params.merge(service: attributes_for(:service),
                                         token: item.token)

        expect(Service.last.item).to eq(item)
      end

      specify "sets the user as the approver by default" do
        user = create :user
        item = create :item, user: user

        post :create, valid_params.merge(service: attributes_for(:service),
                                         token: item.token)

        expect(Service.last.approver).to eq(user)
      end
    end

    context "logged in company" do
      specify "can create service (from the permalinked page)" do
        item = create :item, :with_user
        company = create :company
        sign_in company

        expect do
          post :create, valid_params.merge(service: attributes_for(:service),
                                           token: item.token)
        end.to change { Service.count }.by(1)
      end

      specify "can not set any company" do
        item = create :item, :with_user
        company = create :company
        other_company = create :company
        sign_in company

        post :create, valid_params.merge(
          service: attributes_for(:service).merge(company_id: other_company.id),
          token: item.token
        )

        expect(Service.last.company).to_not eq(other_company)
      end

      specify "by default sets self as a company" do
        item = create :item, :with_user
        company = create :company
        sign_in company

        post :create, valid_params.merge(service: attributes_for(:service),
                                         token: item.token)

        expect(Service.last.company).to eq(company)
      end

      specify "sets item by default using token value" do
        item = create :item, :with_user
        company = create :company
        sign_in company

        post :create, valid_params.merge(service: attributes_for(:service),
                                         token: item.token)

        expect(Service.last.item).to eq(item)
      end
    end

    context "logged in user" do
      specify "can set any company" do
        company = create :company
        user = create :user
        sign_in user

        post :create, valid_params.merge({
          service: attributes_for(:service).merge({
            company_id: company.id,
            item_id: create(:item, user: user)
          })
        })

        expect(Service.last.company).to eq(company)
      end

      specify "can set any own item" do
        user = create :user
        item = user.items.create!(attributes_for(:item))
        sign_in user

        post :create, valid_params.merge({
          service: attributes_for(:service).merge({
            item_id: item.id
          })
        })

        expect(Service.last.item).to eq(item)
      end

      specify "can not set any other's item" do
        user = create :user
        item = create :item
        sign_in user

        post :create, valid_params.merge({
          service: attributes_for(:service).merge({
            item_id: item.id
          })
        })

        expect(Service.last.item).to_not eq(item)
      end
    end
  end
end
