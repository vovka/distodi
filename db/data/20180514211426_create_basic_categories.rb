class CreateBasicCategories < ActiveRecord::Migration
  def up
    CATEGORIES.each do |category_data|
      category = Category.find_or_create_by name: category_data["name"]

      category.attribute_kinds = category_data["attribute_kinds"].map.with_index do |title, index|
        AttributeKind.find_or_create_by title: title, position: index + 1
      end

      category.service_kinds = category_data["service_kinds"].map do |with_text, title|
        ServiceKind.find_or_create_by with_text: with_text, title: title
      end

      category.action_kinds = category_data["action_kinds"].map do |title|
        ActionKind.find_or_create_by title: title
      end

      category.save
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end

  CATEGORIES = YAML.load <<-EOS
- name: "Car"
  attribute_kinds:
    - Brand
    - Model
    - VIN
    - Year
    - Car subcategory
    - Color
    - Type of body
    - Country of using
    - Country of manufacture
    - Type of engine
    - Fuel type
    - Transmission
    - Miliage
    - Type of complete set
    - Engine displacement
    - Safety features
    - Other options
  service_kinds:
    - [false, "oil + filter"]
    - [false, "gearbox oil"]
    - [false, "brake fluid"]
    - [false, "shock absorbers"]
    - [false, "tires"]
    - [false, "candles"]
    - [false, "wipers"]
    - [false, "brake system"]
    - [false, "ignition"]
    - [false, "lamps and lighting"]
    - [false, "hinges and lids"]
    - [false, "air conditioning"]
    - [false, "power steering"]
    - [false, "engine wiring"]
    - [false, "clutch"]
    - [false, "air filter"]
    - [false, "coolant"]
    - [false, "washer / liquid"]
    - [false, "exhaust system"]
    - [false, "battery"]
    - [false, "chassis"]
    - [false, "cabin filter"]
    - [false, "towbar"]
    - [ true, "engine diagnostics"]
    - [ true, "pruning mechanisms"]
    - [ true, "axle geometry"]
    - [ true, "body works"]
    - [ true, "replacement of other parts"]
    - [ true, "testdrive"]
    - [ true, "Other repair / recommendation:"]
    - [ true, "The next control in km"]
  action_kinds:
    - Control
    - Change
    - Tuning

- name: "Bicycle"
  attribute_kinds:
    - Brand
    - Model
    - Year
    - Bicycle subcategory
    - Color
    - Country of using
    - Country of manufacture
    - Frame size
    - Wheel diameter
    - Gender
    - Frame material
    - Weight
    - Number of gears
    - Suspension
    - Safety features
    - Other options
  service_kinds:
    - [false, "Theads in the frame"]
    - [false, "Cleanin the frame + wheels"]
    - [false, "Cleanin the frame + wheels"]
    - [false, "Degrease the chain + cassette/freewheel"]
    - [false, "Weels"]
    - [false, "Chain"]
    - [false, "Realign brakes + adjust"]
    - [false, "Adjusting brakes"]
    - [false, "Adjusting shifting"]
    - [false, "Adjusting headset"]
    - [false, "Adjusting hubs"]
    - [false, "Truing front + rear wheels"]
  action_kinds:
    - Control
    - Tuning
    - Change

- name: "Tractor"
  attribute_kinds:
    - Brand
    - Model
    - VIN
    - Year
    - Color
    - Country of using
    - Country of manufacture
    - Transmission
    - Miliage
    - Tractor subcategory
    - Front End Loader
    - Electronic / navigation system
    - Rated Engine power hp
    - Hydraulic system
    - Temperature control
    - Safety features
    - Other options
  service_kinds:
    - [false, "Hydraulic pump"]
    - [false, "Hydraulic cylinder"]
    - [false, "Hydraulic hoses"]
    - [false, "Adjustment of valves"]
    - [false, "Starter"]
    - [false, "engine wiring"]
    - [false, "oil + filter"]
    - [false, "clutch"]
    - [false, "air filter"]
    - [false, "coolant"]
    - [false, "battery"]
    - [false, "chassis"]
    - [false, "gearbox oil"]
    - [false, "brake fluid"]
    - [false, "tires"]
    - [false, "brake system"]
    - [false, "power steering"]
    - [false, "Fuel pump"]
    - [false, "Traction steering"]
    - [false, "Cylinder head"]
    - [false, "Hydraulic system"]
    - [ true, "Injectors"]
    - [ true, "engine diagnostics"]
    - [ true, "replacement of other parts"]
    - [ true, "testdrive"]
    - [ true, "Other repair / recommendation:"]
    - [ true, "The next control in km"]
    - [ true, "Сab change"]
  action_kinds:
    - Control
    - Tuning
    - Change

- name: "Yacht"
  attribute_kinds:
    - Brand
    - Model
    - Year
    - Yacht subcategory
    - Color
    - Country of using
    - Country of manufacture
    - Electronic / navigation system
    - Length / Width / Draught
    - Material
    - Displacement
    - Number of cabins
    - Primary Fuel Type
    - Number of decks
    - Fresh water supply
    - Safety features
    - Other options
  service_kinds:
    - [false, "Check of the bilges, liquid under floorboards availability control"]
    - [false, "Maintenance of plumbing equipment and water tanks"]
    - [false, "Cleaning the hull, keel, rudder and propellers from fouling"]
    - [false, "Coating of the ship’s bottom with antifouling liquid"]
    - [false, "Polishing the hull"]
    - [false, "Maintenance and washing of fecal tanks"]
    - [false, "Level check, replacement and topping of working engine fluids"]
    - [false, "Complex vessel washing"]
    - [false, "Cleaning and tightening of lifelines, railings and tents"]
    - [false, "Check of the operating status of automatic and manual pumps."]
    - [false, "Inspection, ventilation and washing of sails"]
    - [false, "Maintenance of rigging, spar, windlass, stoppers"]
    - [false, "Leakproofness inspection of hatches and portholes"]
    - [false, "Check of the means of communication and ship clocks (recharging or replacing batteries)"]
    - [ true, "Seasonal works related to the preservation of vessel"]
    - [ true, "Control of the operating status of the rudder control and the autopilot"]
    - [ true, "Monitoring of the batteries and recharging of them, if necessary"]
    - [ true, "Maintenance of the lateral thrusting propeller"]
    - [ true, "The navigation equipment and weather aids"]
    - [ true, "Work on the ship’s bottom, requiring lifting the boat out of water"]
    - [ true, "Validation test and replacement of spelter"]
    - [ true, "Control of expiry date and the completeness of life saving equipment"]
  action_kinds:
    - Control
    - Tuning
    - Change
  EOS
end
