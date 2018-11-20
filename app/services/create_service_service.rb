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
    @service = item.services.build(service_params.merge(approver: approver, company: approver)).decorate
    service_kinds = params[:service_kind]
    service_fields = params[:service_fields]
    action_kinds = params[:action_kind]

    # if action_kinds == "4" #road
    # else
      if action_kinds != "4" && service_kinds.blank?
        @service.errors.add :service_kinds, :blank
      else
        if approver.nil? || approver.persisted?
          @service.transaction do
            @service.action_kinds = ActionKind.where(id: action_kinds)
            @success = if @service.save
              if action_kinds != "4"
                service_kind_id = service_kinds
                service_kind = ServiceKind.where(id: service_kind_id).first
                service_field = service_kind.service_fields.build(
                  service: @service,
                  text: service_fields ? service_fields[service_kind_id] : ''
                )
                service_field.save
              else
                true
              end
            end
          end
        end
      end
    # end

    if success?
      @service.reload # to fetch new created service_field
      if @service.company.present?
        UserMailer.add_service_email_to_company(@service.company).deliver_later
      end
    end

    [@service, success?]
  end

  def success?
    @success == true
  end
end
