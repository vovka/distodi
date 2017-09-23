class ItemTransferValidator
  EMAIL_REGEX = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i

  attr_reader :user_identifier, :errors
  private     :user_identifier

  def initialize(params)
    @user_identifier = params[:user_identifier]
    @errors = []
  end

  def valid?
    validate
    errors.empty?
  end

  private

  def validate
    validate_recipient_email
  end

  def validate_recipient_email
    errors << I18n.t("validators.transfer_validator.user_identifier_is_not_email") unless email?(user_identifier)
  end

  def email?(str)
    str =~ EMAIL_REGEX
  end
end
