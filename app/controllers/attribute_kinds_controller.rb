class AttributeKindsController < ApplicationController
  before_action :set_attribute_kind, only: [:show, :edit, :update, :destroy]

  # GET /attribute_kinds
  # GET /attribute_kinds.json
  def index
    @attribute_kinds = AttributeKind.all
  end

  # GET /attribute_kinds/1
  # GET /attribute_kinds/1.json
  def show
  end

  # GET /attribute_kinds/new
  def new
    @attribute_kind = AttributeKind.new
  end

  # GET /attribute_kinds/1/edit
  def edit
  end

  # POST /attribute_kinds
  # POST /attribute_kinds.json
  def create
    @attribute_kind = AttributeKind.new(attribute_kind_params)

    respond_to do |format|
      if @attribute_kind.save
        format.html { redirect_to @attribute_kind, notice: 'Attribute kind was successfully created.' }
        format.json { render :show, status: :created, location: @attribute_kind }
      else
        format.html { render :new }
        format.json { render json: @attribute_kind.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attribute_kinds/1
  # PATCH/PUT /attribute_kinds/1.json
  def update
    respond_to do |format|
      if @attribute_kind.update(attribute_kind_params)
        format.html { redirect_to @attribute_kind, notice: 'Attribute kind was successfully updated.' }
        format.json { render :show, status: :ok, location: @attribute_kind }
      else
        format.html { render :edit }
        format.json { render json: @attribute_kind.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attribute_kinds/1
  # DELETE /attribute_kinds/1.json
  def destroy
    @attribute_kind.destroy
    respond_to do |format|
      format.html { redirect_to attribute_kinds_url, notice: 'Attribute kind was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute_kind
      @attribute_kind = AttributeKind.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attribute_kind_params
      params.require(:attribute_kind).permit(:title)
    end
end
