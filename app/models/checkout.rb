class CreditCardValidator < ActiveModel::Validator
  def validate(record)
    [:number, :month, :year, :first_name, :last_name, :verification_value,
      :name, :address1, :city, :state, :country, :zip, :phone].each do |field|
      record.class.validators_on(field).each { |v| v.validate(record) }
    end

    if record.errors.messages.blank?
      if record.credit_card.valid?
        record.purchase
      else
        record.errors.add :base, :invalid
      end
    end
  end
end

class Checkout < ActiveRecord::Base
  LOGIN_ID = ENV["PAYMENT_LOGIN_ID"]
  TRANSACTION_KEY = ENV["PAYMENT_TRANSACTION_KEY"]
  SECRET_KEY = ENV["PAYMENT_SECRET_KEY"]
  DEFAULT_CHARGE_AMOUNT_IN_CENTS = 25_00
  CENTS_DIVIDER = 100.0

  attr_accessor :number, :month, :year, :first_name, :last_name,
                :verification_value, :type, :name, :address1, :city, :state,
                :country, :zip, :phone

  validates_with CreditCardValidator
  validates :number, :month, :year, :first_name, :last_name,
            :verification_value, :name, :address1, :city, :state, :country,
            :zip, :phone,
            presence: true

  def credit_card
    @credit_card ||= begin
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        number: number,
        month: month,
        year: year,
        first_name: first_name,
        last_name: last_name,
        verification_value: verification_value, #verification codes are now required
        # brand: 'visa'
      )
    end
  end

  def purchase
    gateway = ActiveMerchant::Billing::SecurionPayGateway.new(
      login: LOGIN_ID,
      password: TRANSACTION_KEY,
      secret_key: SECRET_KEY
    )

    billing_address = {
      name: name,
      address1: address1,
      city: city,
      state: state,
      country: country,
      zip: zip,
      phone: phone
    }

    options = { address: {}, billing_address: billing_address }
    response = gateway.purchase(charge_amount, credit_card, options)

    if response.success?
      puts "success!"
      true
    else
      # raise StandardError.new( response.message )
      errors.add :base, response.message
    end
  end
end

# == Schema Information
#
# Table name: checkouts
#
#  id            :integer          not null, primary key
#  charge_amount :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
