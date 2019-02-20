class ChartsController < ApplicationController
  layout "item"

  before_action :set_items, :set_item
  before_action :authenticate_user_or_company!

  def index
    authorize(@item, :edit?)
    @charts = Chart.build_collection_for_item(@item,
      from_date: charts_params[:from_date], to_date: charts_params[:to_date]
    )
    respond_to do |format|
      format.html
      format.json do
        charts = @charts.each_with_object({}) do |chart, memo|
          memo[chart.ng_model] = JSON.parse(
            chart.to_json(only: [], methods: %i(labels series data))
          )
        end
        render json: charts
      end
    end
  end

  private

  def charts_params
    modified_params = params.dup
    if modified_params[:from_date].present?
      modified_params[:from_date] = Date.parse(modified_params[:from_date])
    end
    if modified_params[:to_date].present?
      modified_params[:to_date] = Date.parse(modified_params[:to_date])
    end
    modified_params
  end

  def set_items
    @items = current_user_or_company.items.unscope(where: :demo)
  end

  def set_item
    @item = @items.where(id: params[:item_id]).first
  end
end
