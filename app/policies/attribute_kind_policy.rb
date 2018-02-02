class AttributeKindPolicy
  BRAND = "Brand".freeze
  MODEL = "Model".freeze
  YEAR = "Year".freeze
  COUNTRY_OF_USING = "Country of using".freeze
  COUNTRY_OF_MANUFACTURE = "Country of manufacture".freeze
  FUEL_TYPE = "Fuel type".freeze
  TYPE_OF_ENGINE = "Type of engine".freeze
  WEIGHT = "Weight".freeze
  TRANSMISSION = "Transmission".freeze
  GENDER = "Gender".freeze
  WHEEL_DIAMETER = "Wheel diameter".freeze
  CAR_SUBCATEGORY = "Car subcategory".freeze
  TYPE_OF_BODY = "Type of body".freeze
  TYPE_OF_COMPLETE_SET = "Type of complete set".freeze
  ENGINE_DISPLACEMENT = "Engine displacement".freeze
  NUMBER_OF_GEARS = "Number of gears".freeze
  BICYCLE_SUBCATEGORY = "Bicycle subcategory".freeze
  FRAME_MATERIAL = "Frame material".freeze
  TRACTOR_SUBCATEGORY = "Tractor subcategory".freeze
  FRONT_END_LOADER = "Front End Loader".freeze
  TEMPERATURE_CONTROL= "Temperature control".freeze
  YACHT_SUBCATEGORY = "Yacht subcategory".freeze
  MATERIAL = "Material".freeze

  def initialize(attribute_kind)
    @attribute_kind = attribute_kind
  end

  def brand?
    @attribute_kind.title == BRAND
  end

  def model?
    @attribute_kind.title == MODEL
  end

  def year?
    @attribute_kind.title == YEAR
  end

  def country_of_using?
    @attribute_kind.title == COUNTRY_OF_USING
  end

  def country_of_manufacture?
    @attribute_kind.title == COUNTRY_OF_MANUFACTURE
  end

  def fuel_type?
    @attribute_kind.title == FUEL_TYPE
  end

  def type_of_engine?
    @attribute_kind.title == TYPE_OF_ENGINE
  end

  def weight?
    @attribute_kind.title == WEIGHT
  end

  def transmission?
    @attribute_kind.title == TRANSMISSION
  end

  def gender?
    @attribute_kind.title == GENDER
  end

  def wheel_diameter?
    @attribute_kind.title == WHEEL_DIAMETER
  end

  def car_subcategory?
    @attribute_kind.title == CAR_SUBCATEGORY
  end

  def type_of_body?
    @attribute_kind.title == TYPE_OF_BODY
  end

  def type_of_complete_set?
    @attribute_kind.title == TYPE_OF_COMPLETE_SET
  end

  def engine_displacement?
    @attribute_kind.title == ENGINE_DISPLACEMENT
  end

  def number_of_gears?
    @attribute_kind.title == NUMBER_OF_GEARS
  end

  def bicycle_subcategory?
    @attribute_kind.title == BICYCLE_SUBCATEGORY
  end

  def frame_material?
    @attribute_kind.title == FRAME_MATERIAL
  end

  def tractor_subcategory?
    @attribute_kind.title == TRACTOR_SUBCATEGORY
  end

  def front_end_loader?
    @attribute_kind.title == FRONT_END_LOADER
  end

  def temperature_control?
    @attribute_kind.title == TEMPERATURE_CONTROL
  end

  def yacht_subcategory?
    @attribute_kind.title == YACHT_SUBCATEGORY
  end

  def material?
    @attribute_kind.title == MATERIAL
  end
end
