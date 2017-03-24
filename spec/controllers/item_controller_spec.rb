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
end
