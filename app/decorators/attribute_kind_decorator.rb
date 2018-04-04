class AttributeKindDecorator < Draper::Decorator
  delegate_all

  VALUES = {
    AttributeKindPolicy::FUEL_TYPE => ["Petrol", "Diesel", "Biodiesel",
                                        "Propane", "Metan", "Electricity",
                                        "Solid fuels"],
    AttributeKindPolicy::TYPE_OF_ENGINE => ["Gasoline", "Diesel", "Biodiesel",
                                    "Electric", "Hybrid", "Steam"],
    AttributeKindPolicy::TRANSMISSION => ["Manual", "Automatic",
                                          "Robotic", "Variator"],
    AttributeKindPolicy::GENDER => ["Male", "Female", "Male - Female"],
    AttributeKindPolicy::CAR_SUBCATEGORY => ["Passenger car", "Truck", "SUV",
                                          "Campervan", "Mini truck", "Van",
                                          "Minivan"],
    AttributeKindPolicy::TYPE_OF_BODY => ["Microcar", "Subcompact car",
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
    AttributeKindPolicy::TYPE_OF_COMPLETE_SET => ["Basic", "Standart", "Classic",
                                                  "Maximum", "Luxury"],
    AttributeKindPolicy::BICYCLE_SUBCATEGORY => ["Electric bicycle", "Cross country", "Downhill",
                                                 "Road racing", "Triathlon",
                                                  "Track", "Cruiser", "Touring",
                                                  "Cyclocross", "Dutch", "Fatbike",
                                                  "BMX", "Trial", "Folding",
                                                  "Enduro", "Dirt jump",
                                                  "Freeride"],
    AttributeKindPolicy::FRAME_MATERIAL => ["Steel", "Hi Tensile", "Cromomolibden",
                                            "Aluminium", "Magnesium", "Carbon",
                                            "Titanium"],
    AttributeKindPolicy::TRACTOR_SUBCATEGORY => ["Utility tractors", "Row crop tractor", "Orchard type",
                                            "Industrial tractor", "Garden tractor", "Rotary tillers",
                                            "Implement carrier", "Earth moving tractors"],
    AttributeKindPolicy::FRONT_END_LOADER => ["Grain bucket", "Screening bucket", "Snow bucket",
                                            "4 in 1 bucket", "2 in 1 bucket", "Grass fork",
                                            "Wood fork", "Soft clamp", "Pallet fork", "Fork", "Snow blower",
                                            "Sweeper", "Snow blade", "V snow blade"],
    AttributeKindPolicy::TEMPERATURE_CONTROL => ["Yes", "No"],
    AttributeKindPolicy::YACHT_SUBCATEGORY => ["Powerboat & Motorboat", "Cuddy",
                                                "Cruiser", "Jet Boat",
                                                "Pontoon & Deck Boat", "Runabout",
                                                "Ski & Wakeboarding Boat", "Other Powerboat",
                                                "Sailboat"],
    AttributeKindPolicy::MATERIAL => ["Steel", "Wood", "Aluminium",
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
    elsif country_of_using? || country_of_manufacture?
      :country_select
    else
      :text_field
    end
  end

  def input_arguments
    if brand?
      # context[:item].selected_category.brand_options.map { |brand| [brand.name, brand.name] },
      [
        ActionController::Base.helpers.options_for_select(context[:item].selected_category.brand_options.map { |brand| [brand.name, brand.name] }, selected: context[:item].selected_brand.try(:name) || "BMW"),
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
      [
        context[:item].selected_brand.model_options.map { |model| [model.name, model.name] },
        { selected: characteristic.try(:value) },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value),
          disabled: characteristic.try(:value).present?,
          chosen: ""
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
          disabled: characteristic.try(:value).present?,
          chosen: ""
        }
      ]
    elsif weight?
      [
        (2..50).step(0.5).map { |i| "#{i} kg" },
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          chosen: ""
        }
      ]
    elsif engine_displacement?
      [
        (0.5..20).step(0.5).map { |i| "#{i} L" },
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          chosen: ""
        }
      ]
    elsif wheel_diameter?
      [
        (8..30).map { |i| "#{i} inch" },
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          chosen: ""
        }
      ]
    elsif number_of_gears?
      [
        (1..40).map { |i| "#{i}" },
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          chosen: ""
        }
      ]
    elsif country_of_using? || country_of_manufacture?
      [
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          chosen: ""
        }
      ]
    elsif fuel_type? || type_of_engine? || transmission? || gender? || car_subcategory? ||
          type_of_body? || type_of_complete_set? || bicycle_subcategory? ||
          frame_material? || tractor_subcategory? || front_end_loader? || temperature_control? ||
          yacht_subcategory? || material?
      [
        values,
        { selected: characteristic.try(:value).presence },
        { name: "item[characteristics[#{id}]]",
          id: "characteristic#{id}",
          value: characteristic.try(:value).presence,
          chosen: ""
        }
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
