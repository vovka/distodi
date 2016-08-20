class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_item, only: [:new]

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
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create


    @service = Service.new(service_params)

    service_kinds = params[:service_kind]
    service_fields = params[:service_fields]

    @service.transaction do
      p "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      @service.save
        service_kinds.each do |key, value|
          p key
          service_kind = ServiceKind.find(key)
          service_field = service_kind.service_fields.build(service: @service, text: service_fields[key])
          service_field.save
        end
        redirect_to @service, notice: 'Service was successfully created.'
    end


    #
    # respond_to do |format|
    #   if @service.save
    #     format.html { redirect_to @service, notice: 'Service was successfully created.' }
    #     format.json { render :show, status: :created, location: @service }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @service.errors, status: :unprocessable_entity }
    #   end
    # end
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
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:item_id, :control_date)
  end
end
