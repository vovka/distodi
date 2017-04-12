class ItemNotSpecifiedException < StandardError
end

class NotAuthenticatedError < StandardError
end

class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :set_item, only: [:new]
  before_action :authenticate_user!, except: [:company_service, :create,
                                              :approve, :decline]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new(item: @item)
    @service_kinds = @item.category.service_kinds
    @action_kinds = @item.category.action_kinds
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json

  # TODO Refactor
  def create
    item = if user_signed_in?
             current_user.items.find_by_id(params[:service][:item_id])
           elsif params[:token].present?
             Item.find_by_token(params[:token])
           end
    approver = if user_signed_in?
                 Company.where(id: service_params[:company_id]).first
               elsif item.present?
                 item.user
               else
                 raise ItemNotSpecifiedException
               end

    @service = Service.new(service_params.merge(approver: approver, item: item))
    service_kinds = params[:service_kind]
    service_fields = params[:service_fields]
    action_kinds = params[:action_kind].keys

    @service.transaction do
      @service.action_kinds = ActionKind.find(action_kinds)
      @service.save
      service_kinds.keys.each do |service_kind_id|
        service_kind = ServiceKind.find(service_kind_id)
        service_field = service_kind.service_fields.build(
          service: @service,
          text: service_fields ? service_fields[service_kind_id] : ''
        )
        service_field.save
      end

      if @service.company.present?
        UserMailer.add_service_email(@service.item.user).deliver_now!
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
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to @service.item, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def company_service
    item = Item.find_by(token: params[:token])
    @service = Service.new(item: item)
    @service_kinds = item.category.service_kinds
    @action_kinds = item.category.action_kinds
  end

  def confirm
    @service.toggle!(:confirmed)
    CompanyMailer.service_confirmed_email(@service.company).deliver!
    redirect_to @service.item
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
      @service = Service.find(params[:id])
    end

    def set_item
      @item = Item.find(params[:item_id])
    end

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def service_params
      if company_signed_in?
        params.require(:service)
              .merge(company_id: current_company.id)
              .permit(:control_date, :picture, :price, :company_id)
      elsif user_signed_in?
        params.require(:service)
              .permit(:control_date, :picture, :price, :company_id)
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
      reason = params.fetch(:service, {}).fetch(:reason, Faker::Lorem.sentence)
      if service.try(:"#{action}!", reason)
        flash[:notice] = t(".success")
      else
        flash[:error] = t(".fail")
      end
      redirect_back :root
    end
end
