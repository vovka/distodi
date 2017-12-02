class ItemsController < ApplicationController
  layout 'item', except: [:show_for_company]

  before_action :set_item, only: [:show, :edit, :update, :destroy, :transfer,
                                  :receive]
  before_action :authenticate_user!, except: :show_for_company
  before_action :authenticate_user_or_company!, only: :show_for_company

  def index
    @items = Item.unscoped.where(user: current_user)
  end

  def show
    @items = Item.unscoped.where(user: current_user)
    @services = @item.services.includes(:service_fields, :action_kinds).decorate
    render "dashboard"
  end

  def new
    @item = current_user.items.build
    @item.can_generate_item_id_code?
    @items = [@item]
    @attributes = AttributeKind.all
  end

  def create
    @items = current_user.items
    @item = Item.new(item_params)
    @item.user = current_user

    @item.characteristics = characteristics_params.map do |key, value|
      attribute_kind = @item.category.attribute_kinds.find(key)
      Characteristic.new(attribute_kind: attribute_kind, value: value)
    end if characteristics_params.any?

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

    if characteristics_params.any?
      characteristics_params.select { |_, v| v.present? }.map do |key, value|
        characteristic = @item.characteristics.find { |c| c.attribute_kind_id == key.to_i }
        if characteristic.present?
          if characteristic.value.blank?
            characteristic.update(value: value)
          end
        else
          attribute_kind = @item.category.attribute_kinds.find(key)
          @item.characteristics << Characteristic.new(attribute_kind: attribute_kind, value: value)
        end
      end
    end

    if @item.update(update_item_params)
      redirect_to @item
    else
      render :edit
    end
  end

  def destroy
    authorize @item
    if current_user.valid_password?(params[:item][:password])
      @item.destroy
      redirect_to @item.user, notice: t(".success")
    else
      redirect_to :back, notice: t(".password_invalid")
    end
  end

  def dashboard
    @items = Item.unscoped.where(user: current_user)
    @services = Service.unscoped.includes(:item, :company, :approver, :action_kinds, :service_fields => :service_kind).where(item: @items).decorate
    render "empty_items_services" if @items.blank?
  end

  def show_for_company
    @item = Item.find_by(token: params[:token]) || Item.new
    authorize @item
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
    validator = ItemTransferValidator.new(params)
    if validator.valid?
      TransferService.new(@item, params[:user_identifier], current_user).perform
      flash[:notice] = t(".success")
    else
      flash[:error] = validator.errors.join(". ")
    end
    redirect_to edit_item_path(@item)
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
    params.require(:item).permit(:title, :picture, :picture2, :picture3, :picture4, :picture5, :category_id, :token, :comment)
  end

  def update_item_params
    params.require(:item).permit(:title, :picture, :picture2, :picture3, :picture4, :picture5, :comment)
  end

  def characteristics_params
    category = if @item.present?
      @item.category
    elsif item_params[:category_id].present?
      Category.find(item_params[:category_id])
    end
    attribute_kind_ids = if category.present?
      category.attribute_kinds.pluck(:id).map(&:to_s)
    else
      []
    end
    params.require(:item).require(:characteristics).permit(attribute_kind_ids)
  end
end
