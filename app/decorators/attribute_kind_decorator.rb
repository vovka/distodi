class AttributeKindDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def input_helper
    if brand? || model?
      :select
    else
      :text_field
    end
  end

  def input_arguments
    if brand?
      [
        context[:item].selected_category.brand_options.map { |brand| [brand.name, brand.name] },
        { selected: context[:item].selected_brand.name },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value),
          class: "brand_options" }
      ]
    elsif model?
      [
        context[:item].selected_brand.model_options.map { |model| [model.name, model.name] },
        { selected: characteristic.try(:value) },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value) }
      ]
    else
      [
        { id: "characteristic#{id}",
          value: characteristic.try(:value) }
      ]
    end
  end

  def characteristic
    @characteristic ||= context[:item].characteristics.find { |c| c.attribute_kind == object }
  end
end
