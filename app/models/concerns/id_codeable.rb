module IdCodeable
  extend ActiveSupport::Concern

  included do
    validate :can_generate_id_code?, if: ->(record) { record.id_code.blank? }

    after_save :ensure_id_code, if: ->(record) { record.id_code.blank? }
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
    if record.user.blank?
      record.errors.add(:user, I18n.t(".errors.messages.user_must_be_present"))
    else
      if record.user.country.blank?
        record.errors.add(:user, I18n.t(".errors.messages.country_must_be_present"))
      else
        record.errors.add(:user, I18n.t(".errors.messages.country_must_be_real")) if country_object.blank?
      end
    end
    record.errors.add(:category, I18n.t(".errors.messages.category_must_be_present")) if record.category.blank?
  end

  def serial_number_id_code
    record.id.to_s(26)
          .tr("0123456789abcdefghijklmnopq", "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
          .rjust(4, "A")
  end

  def country_id_code
    country = country_object
    country.try(:number) || "???"
  end

  def country_object
    @country_object ||= ISO3166::Country.find_country_by_name record.user.country
  end

  def category_id_code
    Kernel.format "%04d", record.category.try(:id).to_i
  end
end

#####

class ItemIdCodeDecorator < BaseIdCodeDecorator
  def can_generate_id_code?
    super
    if record.user.present?
      record.errors.add(:user, I18n.t(".errors.messages.first_name_must_be_present")) if record.user.first_name.blank?
      record.errors.add(:user, I18n.t(".errors.messages.last_name_must_be_present")) if record.user.last_name.blank?
    end
  end

  def model_id_code
    "D"
  end

  def date_id_code
    record.characteristics
          .includes(:attribute_kind)
          .where(attribute_kinds: { title: "Year" })
          .first.try(:value).presence || record.created_at.year
  end

  def user_id_code
    "#{record.user.first_name.try(:first) || "?"}#{record.user.last_name.try(:first) || "?"}"
  end
end

#####

class ServiceIdCodeDecorator < BaseIdCodeDecorator
  def can_generate_id_code?
    super
    record.errors.add(:action_kinds, I18n.t(".errors.messages.at_least_one_action_kind_must_be_present")) if record.action_kinds.blank?
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
