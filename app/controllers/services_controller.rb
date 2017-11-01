class ServicesController < ApplicationController
  respond_to :html, :json, :js

  layout "item"

  before_action :set_service, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :set_item, only: [:new]
  before_action :authenticate_user!, except: [:company_service, :create,
                                              :approve, :decline]
  before_action :authenticate_user_or_company!,
                only: [:create, :approve, :decline]

  before_action :convert_reminder_values, only: :create

  # GET /services/new
  def index
    @services = current_user.services.includes(:service_fields, :action_kinds)
    respond_to do |format|
      format.html
      format.csv { send_data Service.to_csv(@services) }
    end
  end

  def new
    if @service.present?
      @item ||= @service.item
    else
      @service ||= Service.new(item: @item).decorate
    end
    authorize @service
    @service_kinds = @item.category.service_kinds
    @action_kinds = @item.category.action_kinds
  end

  # POST /services
  # POST /services.json
  # TODO: Refactor
  def create
    item = if user_signed_in?
             current_user.items.unscope(where: :demo).find_by_id(params[:service][:item_id])
           elsif params[:token].present?
             Item.find_by_token(params[:token])
           end
    raise ItemNotSpecifiedException if item.blank?
    approver = if user_signed_in?
                 if params[:new_company].present?
                   if email_present?(params[:new_company])
                     find_company_by_email(params[:new_company])
                   else
                     send_invite(params[:new_company])
                   end
                 else
                   Company.where(id: service_params[:company_id]).first
                 end
               else
                 item.user
               end

    @service = item.services.build(service_params.merge(approver: approver)).decorate
    service_kinds = params[:service_kind]
    service_fields = params[:service_fields]
    action_kinds = params[:action_kind].keys

    result = nil
    @service.transaction do
      @service.action_kinds = ActionKind.find(action_kinds)
      result = if @service.save
        service_kinds.keys.map do |service_kind_id|
          service_kind = ServiceKind.find(service_kind_id)
          service_field = service_kind.service_fields.build(
            service: @service,
            text: service_fields ? service_fields[service_kind_id] : ''
          )
          service_field.save
        end.inject(:&)
      end
    end

    if result.present?
      if @service.company.present?
        UserMailer.add_service_email_to_company(@service.company).deliver_later
      end

      if user_signed_in?
        redirect_to user_path(current_user),
                    notice: 'Service was successfully created.'
      elsif company_signed_in?
        redirect_to company_path(current_company),
                    notice: 'Service was successfully created.'
      else
        flash[:notice] = t(".unauthorized_success_notice")
        redirect_back :root
      end
    else
      flash[:error] = t(".error")
      new
      render :new
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id]).decorate
    authorize @service
    @service_kinds = @service.item.category.service_kinds
    @action_kinds = @service.item.category.action_kinds
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    authorize @service
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service.item, notice: t(".notice") }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json do
          render json: @service.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    authorize @service
    @service.destroy
    respond_to do |format|
      format.html {redirect_to @service.item, notice: t(".notice") }
      format.js { head :ok }
      format.json { head :no_content }
    end
  end

  def company_service
    item = Item.find_by(token: params[:token])
    @service = Service.new(item: item)
    @service_kinds = item.category.service_kinds
    @action_kinds = item.category.action_kinds
  end

  def approve
    approval :approve
  end

  def decline
    approval :decline
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id]).decorate
    end

    def email_present?(email)
      Company.where(email: email).first.present?
    end

    def set_item
      @item = Item.unscoped.find(params[:item_id])
    end

    def find_company_by_email(email)
      Company.where(email: email).first
    end

    def send_invite(email)
      Company.invite!(email: email, active: false)
    end

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def service_params
      if company_signed_in?
        params.require(:service)
              .merge(company_id: current_company.id)
              .permit(:control_date, :picture, :price, :company_id,
                      :reminder_custom, reminders_predefined: [])
      elsif user_signed_in?
        params.require(:service)
              .permit(:control_date, :picture, :price, :company_id,
                      :reminder_custom, reminders_predefined: [])
      else
        params.require(:service).permit(:control_date, :picture, :price)
      end
    end

    def approval(action)
      throw NoMethodError unless %i(approve decline).include?(action)
      throw NotAuthenticatedError if current_user_or_company.blank?
      service = current_user_or_company.assigned_services
                                       .where(id: params[:id])
                                       .first
      reason = params.fetch(:service, {}).fetch(:reason, "")
      if service.try(:"#{action}!", reason)
        flash[:notice] = t(".success")
      else
        flash[:error] = t(".fail")
      end
      redirect_back :root
    end

    def convert_reminder_values
      params[:service][:reminder_custom] = if params[:service][:reminder_custom].present?
        Time.zone.parse(params[:service][:reminder_custom]).to_date
      end
      if params[:service][:reminders_predefined].present?
        params[:service][:reminders_predefined].reject!(&:blank?)
        params[:service][:reminders_predefined] = if params[:service][:reminders_predefined].present?
          params[:service][:reminders_predefined].map &:to_i
        end
      end
    end
end
