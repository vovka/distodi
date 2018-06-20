class ItemDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  delegate :brand_options, to: :selected_category

  def selected_brand
    @selected_brand ||= if brand_options.any?
      if selected_brand_option.present?
        selected_brand_option
      elsif brand_characteristic.present?
        brand_options.where(name: brand_characteristic.value).first
      else
        Struct.new(:name, :model_options).new("Please, select brand", [])
      end
    end
  end

  def selected_category
    @selected_category ||= Category.where(id: context[:category_id]).first
  end

  private

  def selected_brand_option
    @selected_brand_option ||= brand_options.where(name: context[:brand_option_id]).first
  end

  def brand_characteristic
    @brand_characteristic ||= characteristics.find { |c| c.attribute_kind == attribute_kinds.find { |a| a.title == "Brand" } }
  end
end
