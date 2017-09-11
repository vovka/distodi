class NotificationsController < ApplicationController
  def read
    notification = Notification.find params[:id]
    authorize notification
    if notification.update read: true
      head :ok
    else
      head :fail
    end
  end
end
