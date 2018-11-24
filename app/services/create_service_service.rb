class CreateServiceService
  attr_reader :item, :approver, :params, :service_params, :service
  private     :item, :approver, :params, :service_params

  def initialize(item, approver, params, service_params)
    @item = item
    @approver = approver
    @params = params
    @service_params = service_params
  end

  def perform
    new_service_attributes = service_params.merge(
      approver: approver,
      company: approver,
      action_kind_ids: [params[:action_kind]],
      service_fields_attributes: [{
        service_kind_id: params[:service_kind],
        text: params[:service_fields] ? params[:service_fields][params[:service_kind]] : ''
      }]
    )
    @service = item.services.create(new_service_attributes)

    if @service.persisted?
      @service.reload # to fetch new created service_field
      if @service.company.present?
        UserMailer.add_service_email_to_company(@service.company).deliver_later
      end
    end

    @service
  end
end
