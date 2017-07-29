class CheckoutDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def charge(amount)
    amount * Checkout::CENTS_DIVIDER.to_i
  end

  def charge_label(amount)
    number_to_currency amount
  end

  def charge_amount
    value = super.to_i
    if value < 1
      self.charge_amount = nil
    else
      value / Checkout::CENTS_DIVIDER
    end
  end

  alias_method :charge_custom_amount, :charge_amount
end
