require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe "POST #read" do
    it "sets notification status to read" do
      user = create :user
      sign_in user
      notification = create :notification, user: user

      expect do
        xhr :post, :read, id: notification.to_param
      end.to change { notification.reload.read }.from(false).to(true)
    end

    specify "user can't read others notifications" do
      bypass_rescue
      user = create :user
      sign_in user
      notification = create :notification, user: create(:user)

      expect do
        xhr :post, :read, id: notification.to_param
      end.to raise_error(Pundit::NotAuthorizedError).and not_change { notification.reload.read }
    end
  end
end
