describe ItemsController do
  render_views

  def valid_attributes(category = nil)
    {
      title: Faker::Lorem.word,
      category_id: category.try(:id),
      picture: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'an_image.jpg'), 'image/jpeg'),
      characteristics: {"1" => "test"}
    }.reject { |_, v| v.nil? }
  end

  describe "GET #index" do
    context "unauthenticated" do
      specify "can not access the page" do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user" do
      specify "can access the page" do
        user = create :user
        sign_in user

        get :index

        expect(response).to have_http_status(:success)
      end

      specify "sees only own items" do
        user = create :user
        my_item = user.items.create! attributes_for(:item).merge(category: create(:category))
        create :item
        sign_in user

        get :index

        expect(assigns(:items)).to eq([my_item])
      end

      specify "sees only own services" do
        user = create :user
        my_item = user.items.create! attributes_for(:item).merge(category: create(:category))
        my_service = my_item.services.create! attributes_for(:service, :with_action_kinds)
        create :item, services: create_list(:service, 1, :with_action_kinds)
        sign_in user

        get :dashboard

        expect(assigns(:services)).to eq([my_service])
      end
    end

    context "company" do
      specify "" do
        company = create :company
        sign_in company

        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET show" do
    it "returns http success" do
      user = create :user
      sign_in user

      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show_for_company" do
    it "does not allow to view for not signed in users" do
      item = create :item

      get :show_for_company, token: item.token

      expect(response).to redirect_to(new_company_session_path)
    end

    it "allows to view for item creator" do
      user = create :user
      item = create :item, user: user
      sign_in user

      get :show_for_company, token: item.token

      expect(response).to have_http_status(:success)
    end

    it "does not allow to view for not item creator" do
      user = create :user
      item = create :item, user: create(:user)
      sign_in user

      expect do
        get :show_for_company, token: item.token
      end.to raise_error(ActionController::RoutingError)
    end

    it "asks for company sign in if token does not exist" do
      user = create :user
      sign_in user

      get :show_for_company, token: "some_not_existent_token"

      expect(response).to redirect_to(new_company_session_path)
    end
  end

  describe "GET #new" do
    context "unauthenticated" do
      specify "can not access the page" do
        get :new

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user" do
      specify "can access the page" do
        user = create :user
        sign_in user

        get :new

        expect(response).to have_http_status(:success)
      end
    end

    context "company" do
      specify "" do
        company = create :company
        sign_in company

        get :new

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "unauthenticated" do
      specify "can not access the page" do
        post :create, item: valid_attributes(create(:category))

        expect(response).to redirect_to(new_user_session_path)
      end

      specify "can not create an item" do
        expect do
          post :create, item: valid_attributes(create(:category))
        end.to_not change { Item.count }
      end
    end

    context "user" do
      specify "can access the page" do
        user = create :user
        sign_in user

        post :create, item: valid_attributes(create(:category))

        expect(response).to redirect_to(Item.last)
      end
    end

    context "company" do
      specify "can not access the page" do
        company = create :company
        sign_in company

        post :create, item: valid_attributes(create(:category))

        expect(response).to redirect_to(new_user_session_path)
      end

      specify "can not create an item" do
        company = create :company
        sign_in company

        expect do
          post :create, item: valid_attributes(create(:category))
        end.to_not change { Item.count }
      end
    end
  end

  describe "GET #edit" do
    context "unauthenticated" do
      specify "can not access the page" do
        item = create :item

        get :edit, id: item.to_param

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user" do
      specify "can edit own item" do
        user = create :user
        item = user.items.create attributes_for(:item)
        sign_in user

        get :edit, id: item.to_param

        expect(response).to be_success
      end

      specify "can not edit others item" do
        user = create :user
        item = create :item, user: create(:user)
        sign_in user

        expect do
          get :edit, id: item.to_param
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "company" do
      specify "can not access the page" do
        company = create :company
        item = create :item
        sign_in company

        get :edit, id: item.to_param

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "unauthenticated" do
      specify "can not access the page" do
        item = create :item

        patch :update, id: item.to_param, item: valid_attributes

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user" do
      specify "can edit own item" do
        user = create :user
        item = user.items.create attributes_for(:item)
        sign_in user

        patch :update, id: item.to_param, item: valid_attributes

        expect(response).to redirect_to(item)
      end

      specify "can not edit others item" do
        user = create :user
        item = create :item, user: create(:user)
        sign_in user

        expect do
          patch :update, id: item.to_param, item: valid_attributes
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "company" do
      specify "can not access the page" do
        company = create :company
        item = create :item
        sign_in company

        patch :update, id: item.to_param, item: valid_attributes

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "unauthenticated" do
      specify "can not access the page" do
        item = create :item

        delete :destroy, id: item.to_param

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user" do
      specify "can delete own item" do
        user = create :user, password: "11111111", password_confirmation: "11111111"
        sign_in user
        item = create :item, user: user

        delete :destroy, id: item.to_param, item: { password: "11111111" }

        expect(response).to redirect_to(item.user)
      end

      it "decrements items count" do
        user = create :user, password: "11111111", password_confirmation: "11111111"
        sign_in user
        item = create :item, user: user

        expect do
          delete :destroy, id: item.to_param, item: { password: "11111111" }
        end.to change { Item.count }.by(-1)
      end

      specify "can not edit others item" do
        user = create :user, password: "11111111", password_confirmation: "11111111"
        item = create :item, user: create(:user)
        sign_in user

        expect do
          delete :destroy, id: item.to_param, item: { password: "11111111" }
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "company" do
      specify "can not delete items" do
        company = create :company, password: "11111111", password_confirmation: "11111111"
        item = create :item
        sign_in company

        delete :destroy, id: item.to_param, item: { password: "11111111" }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST transfer" do
    specify "author can transfer item to another user" do
      user = create :user
      item = create :item, user: user
      another_user = create :user
      sign_in user

      post :transfer, id: item.to_param, user_identifier: another_user.email

      expect(item.reload.transferring_to).to eq(another_user)
    end

    specify "not author can not transfer item" do
      user = create :user
      item = create :item, user: user
      another_user = create :user
      sign_in create(:user)

      expect do
        post :transfer, id: item.to_param, user_identifier: another_user.email
      end.to raise_error(ActionController::RoutingError)
    end

    it "sends email to recipient" do
      user = create :user
      item = create :item, user: user
      another_user = create :user
      sign_in user

      post :transfer, id: item.to_param, user_identifier: another_user.email

      expect(ActionMailer::Base.deliveries.last.to[0]).to eq(another_user.email)
    end

    it "redirects to item" do
      user = create :user
      item = create :item, user: user
      another_user = create :user
      sign_in user

      post :transfer, id: item.to_param, user_identifier: another_user.email

      expect(response).to redirect_to(edit_item_path(item))
    end
  end

  describe "POST receive" do
    specify "recipient can receive transferred item" do
      user = create :user
      recipient = create :user
      item = create :item, user: user, transferring_to: recipient
      sign_in recipient

      post :receive, id: item.to_param

      expect(item.reload.user).to eq(recipient)
    end

    specify "not recipient can not receive item" do
      user = create :user
      recipient = create :user
      item = create :item, user: user, transferring_to: recipient
      sign_in create(:user)

      expect do
        post :receive, id: item.to_param
      end.to raise_error(ActionController::RoutingError)
    end

    it "redirects to items" do
      user = create :user
      recipient = create :user
      item = create :item, user: user, transferring_to: recipient
      sign_in recipient

      post :receive, id: item.to_param

      expect(response).to redirect_to(items_path)
    end
  end

  describe "GET get_attributes" do
    let(:valid_attributes) do
      {
        item_id: @item.to_param,
        category_id: @category.to_param,
        format: :js
      }
    end

    it "disallows view other's item" do
      @item = create :item
      @category = create :category
      sign_in create(:user)

      expect { xhr :get, :get_attributes, valid_attributes }.to raise_error(ActionController::RoutingError)
    end

    it "allows to view own item" do
      user = create :user
      @category = create(:category)
      @item = user.items.create! attributes_for(:item).merge(category: @category)
      sign_in user

      xhr :get, :get_attributes, valid_attributes

      expect(response).to be_success
    end
  end
end
