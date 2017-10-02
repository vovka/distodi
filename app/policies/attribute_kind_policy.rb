class AttributeKindPolicy
  BRAND = "Brand".freeze
  MODEL = "Model".freeze
  YEAR = "Year".freeze
  COUNTRY = "Country".freeze
  MANUFACTURER = "Manufacturer".freeze
  FUEL_TYPE = "Fuel type".freeze
  MOTOR = "Motor".freeze
  WEIGHT = "Weight".freeze
  TRANSMISSION = "Transmission".freeze
  GENDER = "Gender".freeze
  WHEEL_DIAMETER = "Wheel diameter".freeze

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

  def country?
    @attribute_kind.title == COUNTRY
  end

  def manufacturer?
    @attribute_kind.title == MANUFACTURER
  end

  def fuel_type?
    @attribute_kind.title == FUEL_TYPE
  end

  def motor?
    @attribute_kind.title == MOTOR
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
end
