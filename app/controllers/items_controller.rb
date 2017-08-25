class ItemsController < ApplicationController
  layout 'item', except: [:show_for_company]

  before_action :set_item, only: [:show, :edit, :update, :destroy, :transfer,
                                  :receive]
  before_action :authenticate_user!, except: :show_for_company
  before_action :authenticate_user_or_company!, only: :show_for_company

  def dashboard
    @items = Item.unscoped.where(user: current_user)
    @services = Service.unscoped.includes(:item, :company, :approver, :action_kinds, :service_fields => :service_kind).where(item: @items).decorate
    render "empty_items_services" if @items.blank?
  end

  def show
    @items = [@item]
    @services = @item.services.includes(:service_fields, :action_kinds).decorate
    render "dashboard"
  end

  def index
    @items = Item.unscoped.where(user: current_user)
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
    @items = current_user.items
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
    @item = if params[:item_id].present?
      Item.unscoped.where(id: params[:item_id]).first.tap { |item| authorize item }
    else
      current_user.items.build
    end
    @item = @item.decorate context: { category_id: params[:category_id],
                                      brand_option_id: params[:brand_option_id] }
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
    @item = Item.unscoped.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:title, :category_id, :picture, :token)
  end
end
