class ItemsController < ApplicationController
  layout 'item', except: [:show_for_company]

  before_action :set_item, only: [:show, :edit, :update, :destroy, :transfer,
                                  :receive]
  before_action :authenticate_user!, except: :show_for_company
  before_action :authenticate_user_or_company!, only: :show_for_company

  def index
    @items = current_user.items
    @services = current_user.services.includes(:service_fields, :action_kinds).decorate
  end

  def show
    @items = [@item]
    @services = @item.services.includes(:service_fields, :action_kinds).decorate
    render "index"
  end

  def show_for_company
    @item = Item.find_by(token: params[:token]) || Item.new
    authorize @item
  end

  def new
    @item = Item.new
    @items = [@item]
    @attributes = AttributeKind.all
  end

  def create
    characteristics = params[:item].delete(:characteristics)
    @item = Item.new(item_params)
    @item.user = current_user
    @item.characteristics = characteristics.map do |key, value|
      attribute_kind = @item.category.attribute_kinds.find(key)
      Characteristic.new(attribute_kind: attribute_kind, value: value)
    end if characteristics.present?

    if @item.save
      redirect_to @item, notice: t(".notice")
    else
      render :new
    end
  end

  def edit
    @items = [@item]
    authorize @item
    @services = current_user.services.includes(:service_fields, :action_kinds).decorate
  end

  def update
    authorize @item
    if @item.update(item_params)
      redirect_to @item
    else
      render :edit
    end
  end

  def destroy
    authorize @item
    @item.destroy
    redirect_to @item.user, notice: t(".notice")
  end

  def get_attributes
    if params[:item_id].present?
      @item = Item.where(id: params[:item_id]).first
      authorize @item
    end
    category = Category.find(params[:category_id])
    @attributes = category.attribute_kinds
  end

  def transfer
    authorize @item
    TransferService.new(@item, params[:user_identifier], current_user).perform
    redirect_to @item
  end

  def receive
    authorize @item
    @item.update user: current_user, transferring_to: nil
    redirect_to action: :index
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:title, :category_id, :picture, :token)
  end
end
