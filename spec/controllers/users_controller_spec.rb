describe UsersController do
  render_views

  describe "GET #show" do
    it "returns http success" do
      user = create :user
      sign_in user

      get :show, id: user.to_param

      expect(response).to have_http_status(302)
    end

    it "defines an instance variable" do
      user = create :user
      sign_in user

      get :show, id: user.to_param

      expect(assigns(:user)).to be_present
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      user = create :user
      sign_in user

      get :edit, id: user.to_param

      expect(response).to have_http_status(:success)
    end

    it "defines an instance variable" do
      user = create :user
      sign_in user

      get :edit, id: user.to_param

      expect(assigns(:user)).to be_present
    end
  end

  describe "GET #services" do
    it "returns http success" do
      user = create :user
      sign_in user

      get :services, id: user.to_param

      expect(response).to have_http_status(:success)
    end

    it "defines an instance variable" do
      user = create :user
      sign_in user

      get :services, id: user.to_param

      expect(assigns(:user)).to be_present
    end
  end

  describe "GET #companies" do
    it "returns http success" do
      user = create :user
      sign_in user

      get :companies, id: user.to_param

      expect(response).to have_http_status(:success)
    end

    it "defines an instance variable" do
      user = create :user
      sign_in user

      get :companies, id: user.to_param

      expect(assigns(:user)).to be_present
    end
  end

  describe "PATCH #update" do
    it "returns http success" do
      user = create :user
      sign_in user
      valid_attributes = { first_name: Faker::Name.first_name }

      patch :update, { id: user.to_param, user: valid_attributes }

      expect(response).to redirect_to(user)
    end

    it "defines an instance variable" do
      user = create :user
      sign_in user
      valid_attributes = { first_name: Faker::Name.first_name }

      patch :update, { id: user.to_param, user: valid_attributes }

      expect(assigns(:user)).to be_present
    end
  end

  describe "DELETE #destroy" do
    it "returns http success" do
      user = FactoryGirl.create :user, password: "11111111", password_confirmation: "11111111"
      sign_in user

      delete :destroy, id: user.to_param, user: { password: "11111111" }

      expect(response).to redirect_to(root_path)
    end

    it "logs out user" do
      user = FactoryGirl.create :user, password: "11111111", password_confirmation: "11111111"
      sign_in user

      delete :destroy, id: user.to_param, user: { password: "11111111" }

      expect(controller.current_user).to be_nil
    end

    it "defines an instance variable" do
      user = create :user, password: "11111111", password_confirmation: "11111111"
      sign_in user

      delete :destroy, id: user.to_param, user: { password: "11111111" }

      expect(assigns(:user)).to be_present
    end

    it "should increment the count" do
      user = create :user, password: "11111111", password_confirmation: "11111111"
      sign_in user

      expect {
        delete :destroy, id: user.to_param, user: { password: "11111111" }
      }.to change { User.count }.by(-1)
    end
  end
end
