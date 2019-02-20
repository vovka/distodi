class Chart < ActiveRecord::Base
  class ServiceTypesCount < Base
    def labels
      service_counts_grouped_by_kinds.map(&:service_kind_title)
    end

    def series
      chart.name
    end

    def data
      service_counts_grouped_by_kinds.map(&:count)
    end

    private

    def service_counts_grouped_by_kinds
      @_service_counts_grouped_by_kinds_memo ||= chart
        .item.services
        .where(performed_at: chart.from_date..chart.to_date)
        .joins(:service_kinds)
        .select("count(services.id), service_kinds.title as service_kind_title")
        .group("service_kinds.id")
        .to_a
    end
  end
end
