class Chart < ActiveRecord::Base
  class TotalCostsByMonths < Base
    def labels
      (chart.from_date..chart.to_date).map { |m| m.strftime('%Y %m') }.uniq
    end

    def series
      chart.name
    end

    def data
      [
        chart
          .item.services
          .select(
            "date_trunc('month', performed_at) as month, sum(price) as total"
          )
          .group(:month)
          .map(&:total)
      ]
    end
  end
end
