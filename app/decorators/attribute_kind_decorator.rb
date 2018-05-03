class AttributeKindDecorator < Draper::Decorator
  delegate_all

  VALUES = {
    AttributeKindPolicy::FUEL_TYPE => ["Please, select fuel type", "Petrol", "Diesel", "Biodiesel",
                                        "Propane", "Metan", "Electricity",
                                        "Solid fuels"],
    AttributeKindPolicy::TYPE_OF_ENGINE => ["Please, select type of engine", "Gasoline", "Diesel", "Biodiesel",
                                    "Electric", "Hybrid", "Steam"],
    AttributeKindPolicy::TRANSMISSION => ["Please, select transmission", "Manual", "Automatic",
                                          "Robotic", "Variator"],
    AttributeKindPolicy::GENDER => ["Please, select gender", "Male", "Female", "Male - Female"],
    AttributeKindPolicy::CAR_SUBCATEGORY => ["Please, select car subcategory", "Passenger car", "Truck", "SUV",
                                          "Campervan", "Mini truck", "Van",
                                          "Minivan"],
    AttributeKindPolicy::TYPE_OF_BODY => ["Please, select type of body", "Microcar", "Subcompact car",
                                          "Compact car", "Midi-size car",
                                          "Full-size car", "Entry-level luxury car",
                                           "Midi-size luxury car",
                                           "Full-size luxury car",
                                           "Convertible", "Grand tourer",
                                           "Sport car", "Supercar", "Roadster",
                                           "Station wagon", "Compact minivan",
                                           "Minivan", "SUV-Mini", "SUV-Compact",
                                           "SUV-Mid size", "SUV-Full size",
                                           "Pickup truck-mini", "Pickup truck-mid size",
                                           "Pickup truck-full size"],
    AttributeKindPolicy::TYPE_OF_COMPLETE_SET => ["Select type of complete set", "Basic", "Standart", "Classic",
                                                  "Maximum", "Luxury"],
    AttributeKindPolicy::BICYCLE_SUBCATEGORY => ["Please, select bicycle subcategory", "Electric bicycle", "Cross country", "Downhill",
                                                 "Road racing", "Triathlon",
                                                  "Track", "Cruiser", "Touring",
                                                  "Cyclocross", "Dutch", "Fatbike",
                                                  "BMX", "Trial", "Folding",
                                                  "Enduro", "Dirt jump",
                                                  "Freeride"],
    AttributeKindPolicy::FRAME_MATERIAL => ["Please, select frame material", "Steel", "Hi Tensile", "Cromomolibden",
                                            "Aluminium", "Magnesium", "Carbon",
                                            "Titanium"],
    AttributeKindPolicy::TRACTOR_SUBCATEGORY => ["Please, select tractor subcategory", "Utility tractors", "Row crop tractor", "Orchard type",
                                            "Industrial tractor", "Garden tractor", "Rotary tillers",
                                            "Implement carrier", "Earth moving tractors"],
    AttributeKindPolicy::FRONT_END_LOADER => ["Please, select front end loader", "Grain bucket", "Screening bucket", "Snow bucket",
                                            "4 in 1 bucket", "2 in 1 bucket", "Grass fork",
                                            "Wood fork", "Soft clamp", "Pallet fork", "Fork", "Snow blower",
                                            "Sweeper", "Snow blade", "V snow blade"],
    AttributeKindPolicy::TEMPERATURE_CONTROL => ["Please, select temperature control", "Yes", "No"],
    AttributeKindPolicy::YACHT_SUBCATEGORY => ["Please, select yacht subcategory", "Powerboat & Motorboat", "Cuddy",
                                                "Cruiser", "Jet Boat",
                                                "Pontoon & Deck Boat", "Runabout",
                                                "Ski & Wakeboarding Boat", "Other Powerboat",
                                                "Sailboat"],
    AttributeKindPolicy::MATERIAL => ["Please, select material", "Steel", "Wood", "Aluminium",
                                      "Woodcore epoxy", "Concrete",
                                      "Composite", "Epoxy composite", "Grp - sandwich",
                                      "Hypalon neoprene", "Pvc", "Other"]
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
    if brand? || model? || year? || fuel_type? || type_of_engine? || weight? ||
        transmission? || gender? || wheel_diameter? || car_subcategory? || type_of_body? ||
        type_of_complete_set? || engine_displacement? || number_of_gears? ||
        bicycle_subcategory? || frame_material? || tractor_subcategory? || front_end_loader? ||
        temperature_control? || yacht_subcategory? || material?
      :select
    elsif country? || country_of_using? || country_of_manufacture?
      :country_select
    else
      :text_field
    end
  end

  def input_arguments
    if brand?
      # context[:item].selected_category.brand_options.map { |brand| [brand.name, brand.name] },
      [
        ActionController::Base.helpers.options_for_select(["Please, select brand"] + context[:item].selected_category.brand_options.map { |brand| [brand.name, brand.name] }, selected: context[:item].selected_brand.try(:name) || 'Please, select brand', disabled: 'Please, select brand'),
        { selected: context[:item].selected_brand.try(:name) || "BMW" },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value),
          class: "brand_options",
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif model?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select model', disabled: 'Please, select model'}
      end
      [
        ["Please, select model"] + context[:item].selected_brand.model_options.map { |model| [model.name, model.name] },
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value),
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif year?
      default_value = "2000"
      [
        1900..Time.current.to_date.year,
        { selected: characteristic.try(:value).presence || default_value },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence || default_value,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif weight?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select weight', disabled: 'Please, select weight'}
      end
      [
        ["Please, select weight"] + (2..50).step(0.5).map { |i| "#{i} kg" },
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif engine_displacement?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select engine displacement', disabled: 'Please, select engine displacement'}
      end
      [
        ["Please, select engine displacement"] + (0.5..20).step(0.5).map { |i| "#{i} L" },
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif wheel_diameter?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select wheel diameter', disabled: 'Please, select wheel diameter'}
      end
      [
        ["Please, select wheel diameter"] + (8..30).map { |i| "#{i} inch" },
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif number_of_gears?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select number of gears', disabled: 'Please, select number of gears'}
      end
      [
        ["Please, select number of gears"] + (1..40).map { |i| "#{i}" },
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif country? || country_of_using? || country_of_manufacture?
      [
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif fuel_type?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select fuel type', disabled: 'Please, select fuel type'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif type_of_engine?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select type of engine', disabled: 'Please, select type of engine'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif transmission?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select transmission', disabled: 'Please, select transmission'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif gender?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select gender', disabled: 'Please, select gender'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif car_subcategory?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select car subcategory', disabled: 'Please, select car subcategory'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif type_of_body?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select type of body', disabled: 'Please, select type of body'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif type_of_complete_set?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Select type of complete set', disabled: 'Select type of complete set'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif bicycle_subcategory?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select bicycle subcategory', disabled: 'Please, select bicycle subcategory'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif frame_material?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select frame material', disabled: 'Please, select frame material'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif tractor_subcategory?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select tractor subcategory', disabled: 'Please, select tractor subcategory'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif front_end_loader?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select front end loader', disabled: 'Please, select front end loader'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif temperature_control?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select temperature control', disabled: 'Please, select temperature control'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif yacht_subcategory?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select yacht subcategory', disabled: 'Please, select yacht subcategory'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif material?
      options = if characteristic.try(:value).present?
        {selected: characteristic.try(:value).presence}
      else
        {selected: 'Please, select material', disabled: 'Please, select material'}
      end
      [
        values,
        options,
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    else
      [
        { id: "characteristic#{id}",
          value: characteristic.try(:value),
          placeholder: placeholder,
          disabled: characteristic.try(:value).present?
        }
      ]
    end
  end

  private

  def placeholder
    {
      'Brand' => 'Please, enter brand',
      'Model' => 'Please, enter model',
      'Year' => 'Please, enter year',
      'Car subcategory' => 'Please, enter car subcategory',
      'Bicycle subcategory' => 'Please, enter bicycle subcategory',
      'Yacht subcategory' => 'Please, enter yacht subcategory',
      'Color' => 'Please, enter color',
      'Type of body' => 'Please, enter type of body',
      'Country of using' => 'Please, enter country of using',
      'Country of manufacture' => 'Please, enter country of manufacture',
      'Frame size' => 'Please, enter frame size',
      'Wheel diameter' => 'Please, enter wheel diameter',
      'Type of engine' => 'Please, enter type of engine',
      'Fuel type' => 'Please, enter fuel type',
      'Transmission' => 'Please, enter transmission',
      'Miliage' => 'Please, enter miliage',
      'Gender' => 'Please, enter gender',
      'Frame material' => 'Please, enter frame material',
      'Weight' => 'Please, enter Weight',
      'Number of gears' => 'Please, enter number of gears',
      'Suspension' => 'Please, enter suspension',
      'Type of complete set' => 'Please, enter type of complete set',
      'Engine displacement' => 'Please, enter engine displacement',
      'Tractor subcategory' => 'Please, enter tractor subcategory',
      'Front End Loader' => 'Please, enter front End Loader',
      'Electronic / navigation system' => 'Please, enter system',
      'Rated Engine power hp' => 'Please, enter rated Engine power',
      'Hydraulic system' => 'Please, enter hydraulic system',
      'Temperature control' => 'Please, enter temperature control',
      'Length / Width / Draught' => 'Please, enter values',
      'Material' => 'Please, enter material',
      'Displacement' => 'Please, enter displacement',
      'Number of cabins' => 'Please, enter Number of cabins',
      'Primary Fuel Type' => 'Please, enter primary Fuel Type',
      'Number of decks' => 'Please, enter number of decks',
      'Fresh water supply' => 'Please, enter Fresh water supply',
      'Other options' => 'Please, enter other options',
      'Safety features' => 'Please, enter safety features'
    }.fetch(attribute_kind.title)
  end

  def characteristic
    @characteristic ||= context[:item].characteristics.find { |c| c.attribute_kind == object }
  end

  def values
    VALUES[title].map { |v| [v, v] }
  end
end
