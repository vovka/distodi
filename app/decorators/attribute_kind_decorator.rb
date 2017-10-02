class AttributeKindDecorator < Draper::Decorator
  delegate_all

  VALUES = {
    AttributeKindPolicy::FUEL_TYPE => ["Petrol", "Diesel", "Biodiesel",
                                        "Propane", "Metan", "Solid fuels"],
    AttributeKindPolicy::MOTOR => ["Gasoline", "Diesel", "Biodiesel",
                                    "Electric", "Hybrid", "Steam"],
    AttributeKindPolicy::TRANSMISSION => ["Manual", "Automatic",
                                          "Robotic", "Variator"],
    AttributeKindPolicy::GENDER => ["Male", "Female", "Male - Female"]
  }.freeze

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def input_helper
    if brand? || model? || year? || fuel_type? || motor? || weight? ||
        transmission? || gender? || wheel_diameter?
      :select
    elsif country? || manufacturer?
      :country_select
    else
      :text_field
    end
  end

  def input_arguments
    if brand?
      [
        context[:item].selected_category.brand_options.map { |brand| [brand.name, brand.name] },
        { selected: context[:item].selected_brand.try(:name) },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value),
          class: "brand_options",
          disabled: characteristic.try(:value).present?
        }
      ]
    elsif model?
      [
        context[:item].selected_brand.model_options.map { |model| [model.name, model.name] },
        { selected: characteristic.try(:value) },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value),
          disabled: characteristic.try(:value).present?
        }
      ]
    elsif year?
      default_year = "2000"
      [
        1900..Time.current.to_date.year,
        { selected: characteristic.try(:value).presence || default_year },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence || default_year,
          disabled: characteristic.try(:value).present?
        }
      ]
    elsif weight?
      [
        (2..50).step(0.5).map { |i| "#{i} kg" },
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence }
      ]
    elsif wheel_diameter?
      [
        (8..30).map { |i| "#{i} inch" },
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence }
      ]
    elsif country? || manufacturer?
      [
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence }
      ]
    elsif fuel_type? || motor? || transmission? || gender?
      [
        values,
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence }
      ]
    else
      [
        { id: "characteristic#{id}",
          value: characteristic.try(:value),
          disabled: characteristic.try(:value).present?
        }
      ]
    end
  end

  private

  def characteristic
    @characteristic ||= context[:item].characteristics.find { |c| c.attribute_kind == object }
  end

  def values
    VALUES[title].map { |v| [v, v] }
  end
end
