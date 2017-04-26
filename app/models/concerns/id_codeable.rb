module IdCodeable
  extend ActiveSupport::Concern

  included do
    after_save :ensure_id_code, if: :can_generate_id_code?
  end

  def decorated_self
    @decorated_self ||= "#{self.class.name}IdCodeDecorator"
                        .constantize.new(self)
  end

  delegate :can_generate_id_code?, :model_id_code, :country_id_code,
           :user_id_code, :category_id_code, :date_id_code,
           :serial_number_id_code,
           to: :decorated_self

  def ensure_id_code
    update(id_code: generate_id_code)
  end

  def generate_id_code
    ["#{model_id_code}#{country_id_code}", user_id_code, category_id_code,
     date_id_code, serial_number_id_code].compact.join("-")
  end
end

#####

class BaseIdCodeDecorator
  attr_reader :record
  private :record

  def initialize(record)
    @record = record
  end

  def can_generate_id_code?
    record.id_code.blank? && record.user.present? && record.category.present?
  end

  def serial_number_id_code
    record.id.to_s(26)
          .tr("0123456789abcdefghijklmnopq", "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
          .rjust(4, "A")
  end

  def country_id_code
    country = ISO3166::Country.find_country_by_name(record.user.country)
    country.try(:number)
  end

  def category_id_code
    Kernel.format "%04d", record.category.try(:id).to_i
  end
end

#####

class ItemIdCodeDecorator < BaseIdCodeDecorator
  def model_id_code
    "D"
  end

  def date_id_code
    record.characteristics
          .includes(:attribute_kind)
          .where(attribute_kinds: { title: "Year" })
          .first.try(:value) || record.created_at.year
  end

  def user_id_code
    record.user.first_name.first + record.user.last_name.first
  end
end

#####

class ServiceIdCodeDecorator < BaseIdCodeDecorator
  def can_generate_id_code?
    super && record.action_kinds.any?
  end

  def model_id_code
    record.action_kinds.first.abbreviation
  end

  def date_id_code
    record.created_at.strftime("%d%m%y")
  end

  def user_id_code
    nil
  end
end
