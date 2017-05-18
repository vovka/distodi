class TransferService
  attr_reader :item, :user_identifier, :sender
  private :item, :user_identifier, :sender

  def initialize(item, user_identifier, sender)
    @item = item
    @user_identifier = user_identifier
    @sender = sender
  end

  def perform
    receiver = find_user user_identifier
    if receiver.present?
      transfer item, receiver
      send_notification_to receiver, sender
    end
  end

  private

  def find_user(email)
    User.where(email: email).first
  end

  def transfer(item, receiver)
    item.update transferring_to: receiver
  end

  def send_notification_to(receiver, sender)
    UserMailer.transfer_notification_email(sender, receiver).deliver_now!
  end
end
