class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :show_for_company

  def index
  end

  def show
  end

  def show_for_company
    @item = Item.find_by(token: params[:token])
  end

  def new
    @item = Item.new
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

  end

  def update
  end

  def destroy
    @item.destroy
    redirect_to @item.user, notice: t(".notice")
  end

  def get_attributes
    category = Category.find(params[:category_id])
    @attributes = category.attribute_kinds
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
