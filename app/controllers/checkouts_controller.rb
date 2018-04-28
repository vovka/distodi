class CheckoutsController < InheritedResources::Base
  layout 'item'
  before_action :authenticate_user_or_company!
  before_action :set_amount, only: :create

  def new
    super do
      {
        first_name: current_user_or_company.first_name,
        last_name: current_user_or_company.last_name,
        name: current_user_or_company.full_name,
        address1: current_user_or_company.address,
        city: current_user_or_company.city,
        country: current_user_or_company.decorate.country_object.try(:alpha2),
        zip: current_user_or_company.postal_code,
        phone: current_user_or_company.phone
      }.each { |attribute, value| @checkout.send :"#{attribute}=", value }
      @checkout = @checkout.decorate
    end
  end

  def create
    super do
      @checkout = @checkout.decorate
    end
  end

  # def show
  #   super do
  #     @checkout = @checkout.decorate
  #   end
  # end

  private

    def checkout_params
      params
        .require(:checkout)
        .permit(:charge_amount, :name, :address1, :city, :state, :country, :zip,
                :phone, :number, :month, :year, :first_name, :last_name,
                :verification_value)
        .merge(user_id: current_user_or_company.id)
    end

    def set_amount
      params[:checkout][:charge_amount] = if params[:checkout][:charge_custom_amount].present?
        params[:checkout][:charge_custom_amount].to_i * Checkout::CENTS_DIVIDER
      else
        params[:checkout][:charge_amount]
      end
    end
end
