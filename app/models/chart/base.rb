class Chart < ActiveRecord::Base
  class Base
    attr_reader :chart
    private     :chart

    def initialize(chart)
      @chart = chart
    end

    def labels
      if chart.label_attribute.present?
        result = aggregated_services.map { |s| s.send(chart.label_attribute) }
        if chart.format.present?
          result = result.map { |s| s.send(*chart.format) }
        end
        result
      end
    end

    def series
      chart.name
    end

    def data
      if chart.data_attribute.present?
        result = aggregated_services.map(&chart.data_attribute.to_sym)
        if chart.single_serial?
          result = [result]
        end
        result
      end
    end

    private

    def aggregated_services
      Rails.logger.info chart.name
      @_aggregated_services_memo ||= begin
        result = chart
          .item.services
          .where(created_at: chart.from_date..chart.to_date)

        if chart.select.present?
          result = result.select(chart.select)
        end
        if chart.joins.present?
          result = result.joins(chart.joins.to_sym)
        end
        if chart.group.present?
          result = result.group(chart.group)
        end
        if chart.order.present?
          result = result.order(chart.order)
        end

        result.to_a
      end
    end
  end
end
