class ServicesController < ApplicationController
  respond_to :html, :json, :js

  layout "item"

  before_action :set_service, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :set_item, only: [:new]
  before_action :authenticate_user_or_company!
  before_action :convert_reminder_values, only: :create

  # GET /services/new
  def index
    @services = current_user_or_company.services.includes(:service_fields, :action_kinds)
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
  end

  # POST /services
  # POST /services.json
  # TODO: Refactor
  def create
    # Preparing data
    item = if user_signed_in? || company_signed_in?
             current_user_or_company.items.unscope(where: :demo).find_by_id(params[:service][:item_id])
           elsif params[:token].present?
             Item.find_by_token(params[:token])
           end
    raise ItemNotSpecifiedException if item.blank?
    approver = if user_signed_in? || company_signed_in?
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

    # Performing action
    create = CreateServiceService.new(item, approver, params, service_params.to_h)
    @service = create.perform.decorate

    # Rendering
    if @service.persisted?
      if user_signed_in? || company_signed_in?
        redirect_to item_path(item), notice: t(".success")
      else
        flash[:notice] = t(".unauthorized_success_notice")
        redirect_back :root
      end
    else
      if approver.present? && !approver.persisted?
        flash[:error] = t(".invalid_email")
        flash[:error] += t(".error")
      else
        flash[:error] = t(".error")
      end
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
    @item = @service.item
  end

  def show
    @service = Service.where(id: params[:id]).decorate.first
    @service_policy = ServicePolicy.new(current_user || current_company, @service)
    if @service_policy.edit?
      redirect_to edit_service_path(@service)
    else
      authorize @service
      @service_kinds = @service.item.category.service_kinds
      @action_kinds = @service.item.category.action_kinds
      @item = @service.item
      render @service.road? ? "road_show" : "show"
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    @item = @service.item
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
    @item = Item.find_by(token: params[:token])
    @service = Service.new(item: @item)
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

    def set_item
      @item = Item.unscoped.where(id: params[:item_id]).first
    end

    def set_service
      @service = Service.where(id: params[:id]).decorate.first
    end

    def email_present?(email)
      find_company_by_email(email).present?
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
      default_params = [:control_date, :picture, :picture2, :picture3, :picture4, :price, :comment, :distance, :fuel, :customer, :start_lat, :start_lng, :end_lat, :end_lng]
      if company_signed_in?
        params.require(:service)
              .merge(company_id: current_company.id)
              .permit(default_params + [:company_id,
                      :reminder_custom, reminders_predefined: []])
      elsif user_signed_in? || company_signed_in?
        params.require(:service)
              .permit(default_params + [:company_id,
                      :reminder_custom, reminders_predefined: []])
      else
        params.require(:service).permit(default_params)
      end
    end

    def approval(action)
      throw NoMethodError unless %i(approve decline).include?(action)
      throw NotAuthenticatedError if current_user_or_company.blank?
      @service = current_user_or_company.assigned_services
                                        .where(id: params[:id])
                                        .first
      reason = params.fetch(:service, {}).fetch(:reason, "")
      if @service.try(:"#{action}!", reason)
        blockchain_transaction!
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
