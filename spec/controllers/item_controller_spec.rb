describe ItemsController do
  render_views

  describe "DELETE #destroy" do
    it "returns http success" do
      user = FactoryGirl.create :user
      sign_in user
      item = FactoryGirl.create :item, user: user

      delete :destroy, id: item.to_param

      expect(response).to redirect_to(item.user)
    end

    it "should increment the count" do
      user = FactoryGirl.create :user
      sign_in user
      item = FactoryGirl.create :item, user: user

      expect {
        delete :destroy, id: item.to_param
      }.to change { Item.count }.from(1).to(0)
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

      get :show_for_company, token: item.token

      expect(response).to redirect_to(new_company_session_path)
    end

    it "asks for company sign in if token does not exist" do
      user = create :user
      sign_in user

      get :show_for_company, token: "some_not_existant_token"

      expect(response).to redirect_to(new_company_session_path)
    end
  end
end
