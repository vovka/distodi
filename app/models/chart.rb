class Chart < ActiveRecord::Base
  attr_accessor :item, :from_date, :to_date
  delegate :labels, :series, :data, to: :strategy
  enum chart_type: %i(line bar doughnut radar pie polar-area horizontal-bar
                      bubble base)

  scope :active, -> { where(active: true) }

  acts_as_list

  def self.build_collection_for_item(item, from_date:, to_date:)
    active.order(position: :asc).map do |chart|
      chart.item = item
      chart.from_date = from_date
      chart.to_date = to_date
      chart
    end
  end

  def css_class_name
    name.parameterize
  end

  def ng_model
    css_class_name.underscore.camelize(:lower)
  end

  private

  def strategy
    @_strategy_memo ||= begin
      begin
        "Chart::#{ng_model.camelize}".constantize
      rescue NameError, LoadError
        Chart::Base
      end.new(self)
    end
  end
end

# == Schema Information
#
# Table name: charts
#
#  id              :integer          not null, primary key
#  name            :string
#  chart_type      :integer
#  active          :boolean          default("false")
#  label_attribute :string
#  format          :string           default("{}"), is an Array
#  data_attribute  :string
#  select          :string
#  joins           :string
#  group           :string
#  order           :string
#  single_serial   :boolean          default("false")
#  position        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
