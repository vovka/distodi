class ServiceCSVDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  COLS_TO_EXPORT = [:id_code, :approver_id, :created_at, :updated_at, :item_id,
                    :next_control, :price, :company_id, :status, :reason]
  NONE = ""

  def self.humanized_columns
    COLS_TO_EXPORT.map { |column| column.to_s.humanize }
  end

  def map
    COLS_TO_EXPORT.map { |column| yield send(column) }
  end

  private

  def approver_id
    approver.try(:name) || NONE
  end

  def created_at
    I18n.l super
  end

  def updated_at
    I18n.l super
  end

  def item_id
    item.try(:title) || NONE
  end

  def next_control
    if super.present?
      I18n.l super
    else
      NONE
    end
  end

  def price
    number_to_currency super
  end

  def company_id
    company.try(:name) || NONE
  end

  def status
    super.humanize
  end
end
