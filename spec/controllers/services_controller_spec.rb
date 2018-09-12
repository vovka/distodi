require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  render_views

  def valid_params
    action_kinds = create_list :action_kind, 2
    service_kinds = create_list :service_kind, 3
    {
      "action_kind" => action_kinds.first.to_param,
      "service_kind" => service_kinds.first.to_param,
      "service_fields" => Hash[
        service_kinds.map do |service_kind|
          [service_kind.id.to_s, Faker::Lorem.sentence]
        end
      ]
    }
  end

  describe "GET #new" do
    context "unauthenticated" do
      specify "can not see the page" do
        item = create :item

        get :new, item_id: item.to_param

        expect(response).to redirect_to(new_company_session_path)
      end
    end

    context "user" do
      specify "can see services of own item" do
        user = create :user
        category = create :category, :with_service_kinds, :with_action_kinds
        item = create :item, user: user, category: category
        sign_in user

        get :new, item_id: item.to_param

        expect(response).to be_success
      end

      specify "can not see services of others item" do
        category = create :category, :with_service_kinds, :with_action_kinds
        item = create :item, user: create(:user), category: category
        sign_in create :user

        expect do
          get :new, item_id: item.to_param
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "company" do
      specify "can see the page" do
        company = create :company
        item = create :item, user: company
        sign_in company

        get :new, item_id: item.to_param

        expect(response).to be_success
      end
    end
  end

  describe "PATCH #approve" do
    specify "unauthenticated user can not approve a service" do
      user = create :user
      company = create :company
      item = create :item
      service = create :service, approver: user, company: company, item: item

      expect do
        patch :approve, id: service.to_param, item_id: item.to_param
      end.to_not change { service.reload.status }
    end

    specify "user can approve service assigned to him" do
      user = create :user
      company = create :company
      item = create :item
      service = create :service, approver: user, company: company, item: item
      sign_in user
      stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

      expect do
        patch :approve, id: service.to_param, item_id: item.to_param
      end.to change { service.reload.status }.from(Service::STATUS_PENDING)
                                             .to(Service::STATUS_APPROVED)
    end

    specify "user can not approve service not assigned to him" do
      user = create :user
      other_user = create :user
      company = create :company
      item = create :item
      service = create :service, approver: other_user, company: company, item: item
      sign_in user

      expect do
        patch :approve, id: service.to_param, item_id: item.to_param
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
      stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

      expect do
        patch :approve, id: service.to_param, item_id: user.items.first.to_param
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
        patch :approve, id: service.to_param, item_id: user.items.first.to_param
      end.to_not change { service.reload.status }
    end
  end

  describe "PATCH #decline" do
    specify "unauthenticated user can not decline a service" do
      user = create :user
      company = create :company
      service = create :service, approver: user, company: company

      expect do
        patch :decline, id: service.to_param,
                        service: { reason: Faker::Lorem.sentence }
      end.to_not change { service.reload.status }
    end

    specify "user can decline service assigned to him" do
      user = create :user
      company = create :company
      service = create :service, approver: user, company: company
      sign_in user

      expect do
        patch :decline, id: service.to_param,
                        service: { reason: Faker::Lorem.sentence }
      end.to change { service.reload.status }.from(Service::STATUS_PENDING)
                                             .to(Service::STATUS_DECLINED)
    end

    specify "user can not decline service not assigned to him" do
      user = create :user
      other_user = create :user
      company = create :company
      service = create :service, approver: other_user, company: company
      sign_in user

      expect do
        patch :decline, id: service.to_param,
                        service: { reason: Faker::Lorem.sentence }
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
        patch :decline, id: service.to_param,
                        service: { reason: Faker::Lorem.sentence }
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
        patch :decline, id: service.to_param,
                        service: { reason: Faker::Lorem.sentence }
      end.to_not change { service.reload.status }
    end
  end

  describe "POST #create" do
    context "unauthenticated user" do
      specify "can not create service (from the permalink page)" do
        item = create :item
        expect do
          post :create, valid_params.merge(service: attributes_for(:service),
                                           token: item.token,
                                           item_id: item.to_param)
        end.to_not change { Service.count }
      end
    end

    context "logged in company" do
      specify "can create service (from the permalink page)" do
        company = create :company
        item = company.items.create! attributes_for(:item)
        sign_in company
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        expect do
          post :create, valid_params.merge(service: attributes_for(:service).merge(item_id: item.to_param),
                                           token: item.token)
        end.to change { Service.count }.by(1)
      end

      specify "can not set any company" do
        company = create :company
        item = company.items.create! attributes_for(:item)
        other_company = create :company
        sign_in company
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        post :create, valid_params.merge(
          service: attributes_for(:service).merge(company_id: other_company.id, item_id: item.to_param),
          token: item.token
        )

        expect(Service.last.company).to_not eq(other_company)
      end

      specify "by default sets self as a company" do
        company = create :company
        item = company.items.create! attributes_for(:item)
        sign_in company
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        post :create, valid_params.merge(service: attributes_for(:service).merge(item_id: item.to_param),
                                         token: item.token)

        expect(Service.last.company).to eq(company)
      end

      specify "sets item by default using token value" do
        company = create :company
        item = company.items.create! attributes_for(:item)
        sign_in company
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        post :create, valid_params.merge(service: attributes_for(:service).merge(item_id: item.to_param),
                                         token: item.token)

        expect(Service.last.item).to eq(item)
      end
    end

    context "logged in user" do
      specify "can set any company" do
        user = create :user
        item = user.items.create!(attributes_for(:item))
        company = create :company
        sign_in user
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        post :create, valid_params.merge({
          service: attributes_for(:service).merge({
            company_id: company.id,
            item_id: item.to_param
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
          }),
          item_id: item.to_param
        })

        expect(Service.last.item).to eq(item)
      end

      specify "does not create a service when approver email is invalid" do
        user = create :user
        item = user.items.create!(attributes_for(:item))
        email = 'email invalid'
        sign_in user

        expect do
          post :create, valid_params.merge(
            new_company: email,
            service: attributes_for(:service).merge(
              item_id: item.id
            ),
            item_id: item.to_param
          )
        end.to_not change { Service.count }
      end

      specify "does not create a company when approver email is invalid" do
        user = create :user
        item = user.items.create!(attributes_for(:item))
        email = 'email invalid'
        sign_in user

        expect do
          post :create, valid_params.merge(
            new_company: email,
            service: attributes_for(:service).merge(
              item_id: item.id
            ),
            item_id: item.to_param
          )
        end.to_not change { Company.count }
      end

      specify "sets flash errors when approver email is invalid" do
        user = create :user
        item = user.items.create!(attributes_for(:item))
        email = 'email invalid'
        sign_in user
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        post :create, valid_params.merge(
          new_company: email,
          service: attributes_for(:service).merge(
            item_id: item.id
          ),
          item_id: item.to_param
        )

        expect(flash[:error]).to include I18n.t('services.create.invalid_email')
      end

      specify "invite company" do
        user = create :user
        item = user.items.create!(attributes_for(:item))
        email = 'johndoe@example.com'
        sign_in user
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        expect do
          post :create, valid_params.merge(
            new_company: email,
            service: attributes_for(:service).merge(
              item_id: item.id
            ),
            item_id: item.to_param
          )
        end.to change { Company.count }.by(1)
      end

      it "dosn't invite already registered company" do
        user = create :user
        email = 'johndoe@example.com'
        create :company, email: email
        item = user.items.create!(attributes_for(:item))
        sign_in user
        stub_request(:post, "http://localhost:9292/transactions").to_return(body: {blockchain_hash: "some hash"}.to_json)

        expect do
          post :create, valid_params.merge(
            new_company: email,
            service: attributes_for(:service).merge(
              item_id: item.id
            ),
            item_id: item.to_param
          )
        end.to_not change { Company.count }
      end

      specify "can not set any other's item" do
        user = create :user
        item = create :item
        sign_in user

        expect do
          post :create, valid_params.merge({
            service: attributes_for(:service).merge({
              item_id: item.to_param
            }),
            item_id: item.to_param
          })
        end.to raise_error(ItemNotSpecifiedException)
      end
    end
  end

  describe "GET #edit" do
    context "unauthenticated" do
      specify "can not access the page" do
        service = create :service

        get :edit, id: service.to_param, item_id: service.item.to_param

        expect(response).to be_redirect
      end
    end

    context "user" do
      xspecify "can edit own service until it is confirmed" do
        user = create :user
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user

        get :edit, id: service.to_param, item_id: service.item.to_param

        expect(response).to be_success
      end

      specify "can not edit own service after it is approved" do
        user = create :user
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.approve!

        expect do
          get :edit, id: service.to_param, item_id: service.item.to_param
        end.to raise_error(ActionController::RoutingError)
      end

      specify "can not edit own service after it is declined" do
        user = create :user
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.decline!("any reason")

        expect do
          get :edit, id: service.to_param, item_id: service.item.to_param
        end.to raise_error(ActionController::RoutingError)
      end

      xspecify "can edit own if it was self approved" do
        user = create :user
        service = create :service, approver: nil,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        assign :item, service.item
        sign_in user
        service.approve!

        get :edit, id: service.to_param, item_id: service.item.to_param

        expect(response).to be_success
      end

      specify "can not edit own if it was self declined" do
        user = create :user
        service = create :service, approver: nil,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.decline!("any reason")

        expect do
          get :edit, id: service.to_param, item_id: service.item.to_param
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "company" do
      specify "can not access the page" do
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        sign_in company

        expect do
          get :edit, id: service.to_param, item_id: service.item.to_param
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "PATCH #update" do
    context "unauthenticated" do
      specify "can not access the page" do
        service = create :service

        patch :update, id: service.to_param, service: valid_params

        expect(response).to redirect_to(new_company_session_path)
      end
    end

    context "user" do
      specify "can edit own service until it is confirmed" do
        user = create :user
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user

        patch :update, id: service.to_param, service: valid_params

        expect(response).to redirect_to(service.item)
      end

      specify "can not edit own service after it is approved" do
        user = create :user
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.approve!

        expect do
          patch :update, id: service.to_param, service: valid_params
        end.to raise_error(ActionController::RoutingError)
      end

      specify "can not edit own service after it is declined" do
        user = create :user
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.decline!("any reason")

        expect do
          patch :update, id: service.to_param, service: valid_params
        end.to raise_error(ActionController::RoutingError)
      end

      specify "can not edit own if it was self approved" do
        user = create :user
        service = create :service, approver: nil,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.approve!

        expect do
          patch :update, id: service.to_param, service: valid_params
        end.to raise_error(ActionController::RoutingError)
      end

      specify "can not edit own if it was self declined" do
        user = create :user
        service = create :service, approver: nil,
                                   status: Service::STATUS_PENDING
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.decline!("any reason")

        expect do
          patch :update, id: service.to_param, service: valid_params
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "company" do
      specify "can not access the page" do
        company = create :company
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING
        sign_in company

        expect do
          patch :update, id: service.to_param, service: valid_params
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "DELETE #destroy" do
    context "unauthenticated" do
      specify "can not delete an item" do
        item = create :item
        service = create :service, item: item

        delete :destroy, id: service.to_param, item_id: item.to_param

        expect(response).to be_redirect
      end
    end

    context "user" do
      specify "can delete own service until it is confirmed" do
        user = create :user
        company = create :company
        item = create :item
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING,
                                   item: item
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user

        delete :destroy, id: service.to_param, item_id: item.to_param

        expect(response).to redirect_to(service.item)
      end

      specify "can not delete own service after it is approved" do
        user = create :user
        company = create :company
        item = create :item
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING,
                                   item: item
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.approve!

        expect do
          delete :destroy, id: service.to_param, item_id: item.to_param
        end.to raise_error(ActionController::RoutingError)
      end

      specify "can delete own service after it is declined" do
        user = create :user
        company = create :company
        item = create :item
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING,
                                   item: item
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.decline!("any reason")

        expect do
          delete :destroy, id: service.to_param
        end.to change { Service.count }.by(-1)
      end

      specify "can delete own if it was self approved" do
        user = create :user
        item = create :item
        service = create :service, approver: nil,
                                   status: Service::STATUS_PENDING,
                                   item: item
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.approve!

        delete :destroy, id: service.to_param, item_id: item.to_param

        expect(response).to redirect_to(service.item)
      end

      specify "can delete own if it was self declined" do
        user = create :user
        item = create :item
        service = create :service, approver: nil,
                                   status: Service::STATUS_PENDING,
                                   item: item
        category = create :category, :with_service_kinds, :with_action_kinds
        create :item, user: user, category: category, services: [service]
        sign_in user
        service.decline!("any reason")

        expect do
          delete :destroy, id: service.to_param
        end.to change { Service.count }.by(-1)
      end
    end

    context "company" do
      specify "can not delete other's item" do
        company = create :company
        item = create :item
        service = create :service, approver: company,
                                   status: Service::STATUS_PENDING,
                                   item: item
        sign_in company

        expect do
          delete :destroy, id: service.to_param, item_id: item.to_param
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "GET #company_service" do
    it
  end
end
