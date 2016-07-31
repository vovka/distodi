class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @item = Item.new
    @attributes = AttributeKind.all
  end

  def create
  end

  def edit

  end

  def update
  end

  def destroy
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
    params.require(:item).permit(:title, :category_id)
  end
end
